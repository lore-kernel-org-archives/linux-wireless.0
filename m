Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64217 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1JWKXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 06:23:30 -0400
Received: by wyg36 with SMTP id 36so5278941wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 03:23:29 -0700 (PDT)
Message-ID: <4EA3EB1D.9060001@gmail.com> (sfid-20111023_125617_140105_9A51156D)
Date: Sun, 23 Oct 2011 12:23:25 +0200
From: =?ISO-8859-1?Q?David_T=E4ht?= <dave.taht@gmail.com>
MIME-Version: 1.0
To: bloat-devel@lists.bufferbloat.net,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC] ipv6 over wireless classification issue?
Content-Type: multipart/mixed;
 boundary="------------090600010605090908040405"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090600010605090908040405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

After slowly working my way down from verifying the apps to ECN handling 
and up from the drivers... I've been (also) slowly working on getting 
wireless qos/aqms to work better, on ipv6. (I need to get to having a 
spectrum analyzer or better instrumentation...) I was puzzled about dscp 
marked ipv6 packets responding differently.

Perhaps this is it. I'm not making this a commit yet (untested code!)

d@cruithne:~/git/linux-2.6/include$ git diff
diff --git a/net/wireless/util.c b/net/wireless/util.c
index be75a3a..a11c5f2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -658,6 +658,12 @@ unsigned int cfg80211_classify8021d(struct sk_buff 
*skb)
         case htons(ETH_P_IP):
                 dscp = ip_hdr(skb)->tos & 0xfc;
                 break;
+       case htons(ETH_P_IPV6):
+               dscp = ipv6_get_dsfield(ipv6_hdr(skb)) & 0xfc;
+               break;
+       case htons(ETH_P_ARP):
+               dscp = 4<<5;
+               break;
         default:
                 return 0;
         }


A) Elsewhere in the stack ipv4_get_dsfield is the equivalent of the 
ip_hdr(skb)->tos & 0xfc line
B) It appears ipv6_get_dsfield is safe to call from non-ipv6 enabled 
systems

So my thought would be to also harmonize this with ipv4_get_dsfield...

C) And I doubt that slamming arp packets into the VI queue would be 
acceptable yet (as per the ANTs discussion of a few months back, ARP, 
ND, RA, RS, DHCP, and possibly DNS, ssh (marked interactive), etc might 
do better in the VI queue)
(however this part of the patch is not relevant to the IPv6 issue, it's 
just the patch I wanted to try)

D) Lastly, Later on in this function only dscp's first 3 bits (CS0 - 
CS7) are used to classify packets into the queues, where a mildly saner 
version would use a lookup table to also do sane things with the 
'immediate' bit, perhaps settable via userspace from via sysfs, sysctl, 
or proc.

-- 
Dave Täht


--------------090600010605090908040405
Content-Type: text/x-vcard; charset=utf-8;
 name="dave_taht.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dave_taht.vcf"

begin:vcard
fn;quoted-printable:Dave T=C3=A4ht
n;quoted-printable:T=C3=A4ht;Dave
email;internet:dave.taht@gmail.com
tel;home:1-239-829-5608
tel;cell:0638645374
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------090600010605090908040405--
