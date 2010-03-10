Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from porcine.com ([130.94.188.223]:3131 "EHLO porcine.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab0CJQFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 11:05:00 -0500
Received: from unknown (HELO [192.168.0.172]) ([66.159.230.24])
          (envelope-sender <jimham@porcine.com>)
          by 130.94.188.223 (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 10 Mar 2010 15:58:20 -0000
Message-ID: <4B97C1AC.6020405@porcine.com>
Date: Wed, 10 Mar 2010 07:58:36 -0800
From: Jim Ham <jimham@porcine.com>
Reply-To: jimham@porcine.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Pavel Roskin <proski@gnu.org>
Subject: Re: Athros wireless stopped working
References: <1268102255.10290.24.camel@localhost> <1268187196.3410.14.camel@mj>
In-Reply-To: <1268187196.3410.14.camel@mj>
Content-Type: multipart/mixed;
 boundary="------------050905040202090902090606"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050905040202090902090606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Pavel Roskin wrote:
> On Mon, 2010-03-08 at 18:37 -0800, Jim Ham wrote:
>
>> What I have discovered is that if the ESSID is not active, iwconfig sets
>> it correctly and it sticks. If the ESSID is one that is locally present,
>> iwconfig seems to set it, but it almost immediately reverts to garbage.
>
> Either you have a memory corruption bug in your kernel, or you have some
> buggy userspace tool (it could be a misbehaving NetworkManager or wicd)
> that changes ESSID on the interface as soon as the driver reports
> association.  I haven't seen any similar reports.
Right on! All works in single user mode. On poking around I found that 
the Gnome client for NetworkManager was missing. Once I installed the 
client all started to work. So this is a Debian package management 
issue, along with perhaps a bug in NetworkManager or it's underlying 
utilities.

My distribution is Debian Testing (Squeeze). I'm not sure when 
NetworkManager showed up, but I'm betting that it was coincident with 
the wireless problem.

Thanks for the advice.


>
>> 	Kernel driver in use: ath5k
>
> ath5k is not an example of code quality, but I don't remember any memory
> corruption bugs in it fixed since 2.6.32.
>
> I suggest following steps:
>
> 1) Check for updates for your distribution, install updates, recheck.
>
> 2) Boot to the single user mode, make sure that wpa_supplicant and wicd
> are not running (kill them otherwise) and try setting up the connection
> manually.
>
> 3) Install the latest compat-wireless, recheck.
>
>
>
>
>
> No virus found in this incoming message.
> Checked by AVG - www.avg.com
> Version: 9.0.733 / Virus Database: 271.1.1/2733 - Release Date: 03/09/10 11:33:00
>

--------------050905040202090902090606
Content-Type: text/x-vcard; charset=utf-8;
 name="jimham.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jimham.vcf"

begin:vcard
fn:James Ham
n:Ham;James
org:Porcine Associates
adr:;;244 O'Connor St.;Menlo Park;CA;94025;USA
email;internet:jimham@porcine.com
tel;work:+1 650 326.2669
tel;fax:+1 650 326.1071
x-mozilla-html:FALSE
url:www.porcine.com
version:2.1
end:vcard


--------------050905040202090902090606--
