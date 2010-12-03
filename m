Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34484 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0LCRaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 12:30:01 -0500
Received: by fxm20 with SMTP id 20so2418799fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 09:30:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com>
References: <20101122024208.GA13377@monopoli.naic.edu>
	<AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
	<20101125014511.GA1683@monopoli.naic.edu>
	<AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com>
	<20101126040742.GA5238@monopoli.naic.edu>
	<AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
	<20101130021911.GA18971@monopoli.naic.edu>
	<AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com>
	<20101202002234.GA30670@monopoli.naic.edu>
	<AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com>
	<20101203001052.GA16808@monopoli.naic.edu>
	<AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com>
Date: Fri, 3 Dec 2010 17:29:59 +0000
Message-ID: <AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@googlemail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 3, 2010 at 5:23 PM, Dave Kilroy <kilroyd@googlemail.com> wrote:
> On Fri, Dec 3, 2010 at 12:10 AM, Giacomo Comes <comes@naic.edu> wrote:
>> On Thu, Dec 02, 2010 at 05:46:54PM +0000, Dave Kilroy wrote:
>>> On Thu, Dec 2, 2010 at 12:22 AM, Giacomo Comes <comes@naic.edu> wrote:
>>> > On Wed, Dec 01, 2010 at 09:52:15PM +0000, Dave Kilroy wrote:
>>> >> On Tue, Nov 30, 2010 at 2:19 AM, Giacomo Comes <comes@naic.edu> wrote:
>>> >> wpa_supplicant log indicates it is continuously timing out the scans.
>>> >> I don't know what is going on there.
>>> >>
>>> >> What you can try is to turn off wpa_supplicant roaming, and force
>>> >> wpa_supplicant to connect to the AP with highest priority in your
>>> >> config. Set ap_scan=2 in wpa_supplicant.conf, and set
>>> >>
>>> >> group=TKIP
>>> >> pairwise=TKIP
>>> >>
>>> >> in the network block.
>>> >>
>>> >> This also prevents wpa_supplicant trying to connect to an AP using
>>> >> BSSID, which the agere cards don't support.
>>> >
>>> > Running:
>>> > wpa_supplicant -ieth1 -c wpa_supplicant.conf -f wpa_supplicant.log -dd
>>> >
>>> > wpa_supplicant.conf content:
>>> > ctrl_interface=/var/run/wpa_supplicant
>>> > ctrl_interface_group=0
>>> > ap_scan=2
>>> >
>>> > network={
>>> >        ssid="Comes"
>>> >        psk="<password>"
>>> >        key_mgmt=WPA-PSK
>>> >        priority=5
>>> >        proto=WPA
>>> >
>>> >        group=TKIP
>>> >        pairwise=TKIP
>>> > }
>>>
>>> OK, looks like you're using a newer wpa_supplicant that tries to use
>>> IW_AUTH_MFP which orinoco doesn't know about. I can modify the driver
>>> to silently pass these calls through, but it would be nice if
>>> wpa_supplicant didn't fail because a driver didn't support a
>>> particular option.
>>>
>>> I'll put together a patch to accept an IW_AUTH_MFP call set to NONE or
>>> DISABLED, and fail on REQUIRED. In the meantime you could try use an
>>> older wpa_supplicant. I think I was using 0.7.2 before, but I can't be
>>> sure.
>>
>> wpa_supplicant version is 0.7.3. It's the one included in suse 11.3.
>>
>> About your patch, things are getting better.
>>
>> I have applied the patch and run wpa_supplicant with the configuration
>> showed above. It works, the card associates with the AP.
>> The succesful log is attached.
>> After I removed from wpa_supplicant.conf the two lines:
>> group=TKIP
>> pairwise=TKIP
>> the association still works.
>>
>> But after removing the line: ap_scan=2
>> the association fails.
>> The log is in the second attachment.
>>
>> Also I have included in the 3rd attachement wpa_supplicant.log when
>> NetworkManager is used.

> The failure and NM case are the same. There is still a problem with
> scanning. wpa_supplicant initiates a scan, and it appears to time out.
> Without scan results wpa_supplicant is not able to select an
> appropriate AP.
>
> Is the driver reporting any scanning issues in dmesg while
> wpa_supplicant is running?

Apologies, hit the wrong button again. Including linux-wireless


> Dave.
