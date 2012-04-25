Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46790 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab2DYRV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 13:21:59 -0400
Message-ID: <4F9832AE.6000508@candelatech.com> (sfid-20120425_192203_697628_CA78584E)
Date: Wed, 25 Apr 2012 10:21:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Strange problem with ath9k and ASUS N66U AP.
References: <4F972E3F.4020609@candelatech.com> <4F97449F.5040505@candelatech.com> <20120425060853.GA3324@w1.fi> <4F97987B.7050600@candelatech.com> <4F97B357.1030609@lri.fr>
In-Reply-To: <4F97B357.1030609@lri.fr>
Content-Type: multipart/mixed;
 boundary="------------020300060008030904050900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020300060008030904050900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/25/2012 01:18 AM, Nicolas Cavallari wrote:
> On 25/04/2012 08:23, Ben Greear wrote:
>> On 04/24/2012 11:08 PM, Jouni Malinen wrote:
>>> Either the AP did not receive the first EAPOL-Key 4/4 or processed it
>>> only after retransmitting 3/4. Supplicant side will need to to reply to
>>> retransmitted 3/4 to complete the 4-way handshake. If the AP received
>>> either of these 4/4 messages, it should be fine with the result. If it
>>> didn't receive either, it should disconnect the station. It does not
>>> look like either of those happened.
>>
>> Ok, it seems strange they would have such a lame
>> bug, but maybe they never tried associating several stations at once.
>> (I see around 30% failure rate when using just 15 stations).
>>
>> We have several off-the-shelf APs and home-grown ones (using ath9k) that work fine,
>> even when associating 100+ stations, so at the least the N66U is weird...
>>
>> That said, I'll probably need to attempt a work-around for this.  The only
>> obvious thing I see is the extra RX EAPOL (in all error cases I looked at, and none
>> where it associated properly), and the fact that DHCP just fails to acquire a lease.
>>
>> I'll try adding a hack to detect the duplicate RX EAPOL and bounce the connection
>> if that hits, and see if that helps any...
>>
>
> It could look like the old bug i had, where the station would send
> EAPOL-Key 4/4 encrypted when associating. Normally, the AP should
> disconnect the station, it would retry and hopefully succeed next time,
> and no one would have noticed anything, except this AP doesn't
> disconnect the station and it doesn't recover.
>
> Basically, wpa_supplicant sends the EAPOL-Key 4/4, then adds the PTK/GTK
> in the kernel, but due to scheduling/queuing/buffering of the EAPOL
> packet, it would be sent encrypted with the PTK ...

Maybe it sets the key after the first 4/4 response, and then the
key is already in place when the second 4/4 response is sent?
Should wpa_supplicant remove the key from the kernel before
sending the second 4/4 response?

> If when monitoring, you don't see any plaintext EAPOL-Key 4/4 coming
> from the failed stations, then it could be the same problem.

Maybe that is the case.  I do not see an obvious plain-text response to the
second EAPOL 3/4 message, but there *is* a packet that goes out
in the right time-frame...maybe it's an encrypted 4/4 response packet?

  I'm attaching a filtered capture
(full capture is here:  http://www.candelatech.com/~greearb/misc/13-stas-n66.pcap.gz)

Here are the corresponding logs from supplicant:

1335371251.170525: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta10' added
1335371251.170547: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta10' added
1335371251.280369: sta10: RX EAPOL from c8:60:00:e8:88:b0
1335371251.280445: sta10: Setting authentication timeout: 10 sec 0 usec
1335371251.280458: sta10: IEEE 802.1X RX: version=2 type=3 length=117
1335371251.280463: sta10:   EAPOL-Key type=2
1335371251.280469: sta10:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1335371251.280473: sta10:   key_length=16 key_data_length=22
1335371251.280541: sta10: State: ASSOCIATED -> 4WAY_HANDSHAKE
1335371251.280547: sta10: WPA: RX message 1 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335371251.280571: sta10: RSN: no matching PMKID found
1335371251.281073: sta10: WPA: Sending EAPOL-Key 2/4
1335371252.803896: sta10: RX EAPOL from c8:60:00:e8:88:b0
1335371252.803975: sta10: IEEE 802.1X RX: version=2 type=3 length=175
1335371252.803983: sta10:   EAPOL-Key type=2
1335371252.803989: sta10:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1335371252.803993: sta10:   key_length=16 key_data_length=80
1335371252.804149: sta10: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1335371252.804155: sta10: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335371252.804186: sta10: WPA: Sending EAPOL-Key 4/4
1335371252.804253: sta10: WPA: Installing PTK to the driver
1335371252.804529: sta10: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1335371252.804547: sta10: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32)
1335371252.804626: sta10: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP secure=512 dbg=pairwise-gtk]
1335371252.804633: sta10: Cancelling authentication timeout
1335371252.804639: sta10: State: GROUP_HANDSHAKE -> COMPLETED
1335371252.804645: sta10: CTRL-EVENT-CONNECTED - Connection to c8:60:00:e8:88:b0 completed (auth) [id=0 id_str=]
1335371252.805696: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta10' added
1335371252.830295: sta10: RX EAPOL from c8:60:00:e8:88:b0
1335371252.830330: sta10: IEEE 802.1X RX: version=2 type=3 length=175
1335371252.830335: sta10:   EAPOL-Key type=2
1335371252.830340: sta10:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1335371252.830344: sta10:   key_length=16 key_data_length=80
1335371252.830445: sta10: State: COMPLETED -> 4WAY_HANDSHAKE
1335371252.830452: sta10: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
1335371252.830487: sta10: WPA: Sending EAPOL-Key 4/4
1335371252.830541: sta10: WPA: Installing PTK to the driver
1335371252.839240: sta10: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1335371252.839256: sta10: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32)
1335371252.847235: sta10: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP secure=512 dbg=pairwise-gtk]
1335371252.847250: sta10: Cancelling authentication timeout
1335371252.847259: sta10: State: GROUP_HANDSHAKE -> COMPLETED
1335371440.843881: sta10: BSS: Expire BSS 1 due to age
1335371440.843888: sta10: BSS: Remove id 1 BSSID c0:c1:c0:38:e1:cb SSID 'e3k-2g-1'


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------020300060008030904050900
Content-Type: application/x-gzip;
 name="sta10.pcap.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sta10.pcap.gz"

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
3VQExhAAAA==
--------------020300060008030904050900--
