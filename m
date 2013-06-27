Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:48430 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3F0PVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 11:21:42 -0400
Received: by mail-ve0-f172.google.com with SMTP id jz10so800527veb.31
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 08:21:41 -0700 (PDT)
Message-ID: <51CC5883.3010600@lwfinger.net> (sfid-20130627_172145_112741_E22E429A)
Date: Thu, 27 Jun 2013 10:21:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "shiki.biomernok" <shiki.biomernok@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net> <51CB250A.3060900@gmail.com> <51CB4E31.50502@lwfinger.net> <51CC0F22.7030004@gmail.com>
In-Reply-To: <51CC0F22.7030004@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060806030103060306010402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060806030103060306010402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/27/2013 05:08 AM, shiki.biomernok wrote:
> The closed source driver is not working either.
> It compiled like a charm, and it loads perfectly.
> (I even blacklisted the open-source one!)
>
> But there is nothing in iwconfig or ifconfig.
> Here is the dmesg: http://pastebin.com/EX8h1HfZ
>
> I really don't want to waste your time guys by the way. If there is no way to
> fix it, let's just leave it. (Don't get me wrong I know things can be
> troublesome on Linux and I'm still willing to try anything. I just bet you have
> better things to do. :))

The standard Realtek driver does not have the 8200ND in its device table. Apply 
the attached patch to add the necessary code. This patch was made for the driver 
version that I just sent you privately, but it should work on the other version. 
Please test both with this patch.

Thanks,

Larry



--------------060806030103060306010402
Content-Type: text/plain; charset=UTF-8;
 name="add_8200ND"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="add_8200ND"

SW5kZXg6IHJ0bDgxODhDXzgxOTJDX3VzYl9saW51eF92My40LjRfNDc0OS4yMDEyMTEwNS9v
c19kZXAvbGludXgvdXNiX2ludGYuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBydGw4MTg4Q184MTky
Q191c2JfbGludXhfdjMuNC40XzQ3NDkuMjAxMjExMDUub3JpZy9vc19kZXAvbGludXgvdXNi
X2ludGYuYworKysgcnRsODE4OENfODE5MkNfdXNiX2xpbnV4X3YzLjQuNF80NzQ5LjIwMTIx
MTA1L29zX2RlcC9saW51eC91c2JfaW50Zi5jCkBAIC05Miw2ICs5Miw3IEBAIHN0YXRpYyBz
dHJ1Y3QgdXNiX2RldmljZV9pZCBydHdfdXNiX2lkX3QKIAkvKioqKioqIDgxOTJDVVMgKioq
KioqKiovCiAJe1VTQl9ERVZJQ0UoVVNCX1ZFTkRFUl9JRF9SRUFMVEVLLCAweDgxNzcpfSwv
LzgxOTFjdSAxKjIKIAl7VVNCX0RFVklDRShVU0JfVkVOREVSX0lEX1JFQUxURUssIDB4ODE3
OCl9LC8vODE5MmN1IDIqMgorCXtVU0JfREVWSUNFKDB4MjM1NywgMHgwMTAwKX0sIC8qVFAt
TGluayBXTjgyMDBORCovCiAJe1VTQl9ERVZJQ0UoVVNCX1ZFTkRFUl9JRF9SRUFMVEVLLCAw
eDgxN0MpfSwvLzgxOTJDRS1WQVUgVVNCIG1pbkNhcmQKIAkKIAo=
--------------060806030103060306010402--
