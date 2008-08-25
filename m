Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:33909 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbYHYPBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 11:01:18 -0400
Received: by gv-out-0910.google.com with SMTP id e6so305344gvc.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 08:01:16 -0700 (PDT)
Message-ID: <1ba2fa240808250801p3eb78dc5o78c65511f3f2d9a6@mail.gmail.com> (sfid-20080825_170123_594621_291C97E1)
Date: Mon, 25 Aug 2008 18:01:16 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: PROBLEM: mac80211 and 802.11a does not associate with ap [PATCH]
Cc: "Jan-Espen Pettersen" <sigsegv@radiotube.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1219676032.22954.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48B1EF75.9060704@radiotube.org>
	 <1219676032.22954.22.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2008 at 5:53 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-08-25 at 01:32 +0200, Jan-Espen Pettersen wrote:
>> Hello,
>>
>> Short problem description:
>> mac80211 framework sends a possibly invalid assoc request (802.11a)
>>
>> Patch url download (if the attachment is unusable or stripped):
>> http://www.radiotube.org/mac80211_emptyext.diff
>>
>> PROBLEM DESCRIPTION
>> The association request includes a list of supported data rates.
>>
>> 802.11b: 4 supported rates.
>> 802.11g: 12 (8 + 4) supported rates.
>> 802.11a: 8 supported rates.
>>
>> The rates tag of the assoc request has room for only 8 rates. In case of
>> 802.11g an extended rate tag is appended. However in net/wireless/mlme.c
>> an extended (empty) rate tag is also appended if the number of rates is
>> exact 8.
>
> That seems wrong; shouldn't be sending out an empty IE.
>
> Can you post the patch inline in email, which is the preferred method of
> sending kernel patches?  Also, please include a short description of the
> patch as the subject, a longer explanation at the start of the mail, and
> include your Signed-off-by: with your email address to indicate that you
> are legally able to contribute the patch (ie that its not covered under
> some NDA, obtained illegally, etc).  Even though your patch is one line,
> everyone needs to do this.  Please see:
>
> http://linux.yyz.us/patch-format.html
>
> Your subject should be something like:
>
> mac80211: don't send empty extended rates IE
>
> Thanks!
> Dan
>
This mostly affects Cisco APs, we just hit it as well 2 weeks ago.
Tomas

>> Pseudo-code of current mlme.c implementation:
>>
>> for (i = 0; i < num_rates && i < 8; i++)
>>     ... append_rate ...;
>> if (i == 8) { /* <-- problem */
>>     length = num_rates - i;
>>     ... append ext rate ...;
>> }
>>
>> The correct way to do this should be more like:
>>
>> for (i = 0; i < num_rates && i < 8; i++)
>>     ... append_rate ...;
>> if (i < num_rates) { /* <--note this */
>>     length = num_rates - i;
>>     ... append ext rate ...
>> }
>>
>> A ZyXEL G-570U access point does not accept this empty extended rates
>> tag. It responds with a 'association denied' with code 18 (unsupported
>> rates). I do not know if this is correct behaviour, but as far as I can
>> see it would be wise to not send an empty extended rates tag anyway.
>>
>> Kernel version:
>> Linux version 2.6.27-rc4 (sigsegv@challenger) (gcc version 4.3.1 (Debian
>> 4.3.1-9) ) #9 SMP Sun Aug 24 22:24:27 CEST 2008
>>
>> Wireless card (dmesg):
>> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
>> Linux, 1.2.26kds
>> iwl3945: Copyright(c) 2003-2008 Intel Corporation
>> iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> iwl3945 0000:03:00.0: setting latency timer to 64
>> iwl3945: Detected Intel Wireless WiFi Link 3945ABG
>> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
>>
>> Debug output from mac80211 and iwl3945:
>> phy0: HW CONFIG: freq=5180
>> phy0: HW CONFIG: freq=5180
>> wlan0_rename: Initial auth_alg=0
>> wlan0_rename: authenticate with AP 00:19:cb:2f:4b:95
>> phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x003c
>> A1=00:19:cb:2f:4b:95 A2=00:1b:77:40:82:46 A3=00:19:cb:2f:4b:95
>> phy0: HW CONFIG: freq=5180
>> wlan0_rename: Initial auth_alg=0
>> wlan0_rename: authenticate with AP 00:19:cb:2f:4b:95
>> phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x003c
>> A1=00:19:cb:2f:4b:95 A2=00:1b:77:40:82:46 A3=00:19:cb:2f:4b:95
>> wlan0_rename: RX authentication from 00:19:cb:2f:4b:95 (alg=0
>> transaction=2 status=0)
>> wlan0_rename: authenticated
>> wlan0_rename: associate with AP 00:19:cb:2f:4b:95
>> phy0: TX to low-level driver (len=46) FC=0x0000 DUR=0x003c
>> A1=00:19:cb:2f:4b:95 A2=00:1b:77:40:82:46 A3=00:19:cb:2f:4b:95
>> wlan0_rename: authentication frame received from 00:19:cb:2f:4b:95, but
>> not in authenticate state - ignored
>> wlan0_rename: authentication frame received from 00:19:cb:2f:4b:95, but
>> not in authenticate state - ignored
>> wlan0_rename: RX AssocResp from 00:19:cb:2f:4b:95 (capab=0x421 status=18
>> aid=0)
>> wlan0_rename: AP denied association (code=18)
>> wlan0_rename: associate with AP 00:19:cb:2f:4b:95
>> phy0: TX to low-level driver (len=46) FC=0x0000 DUR=0x003c
>> A1=00:19:cb:2f:4b:95 A2=00:1b:77:40:82:46 A3=00:19:cb:2f:4b:95
>> wlan0_rename: RX AssocResp from 00:19:cb:2f:4b:95 (capab=0x421 status=18
>> aid=0)
>> wlan0_rename: AP denied association (code=18)
>> wlan0_rename: associate with AP 00:19:cb:2f:4b:95
>> phy0: TX to low-level driver (len=46) FC=0x0000 DUR=0x003c
>> A1=00:19:cb:2f:4b:95 A2=00:1b:77:40:82:46 A3=00:19:cb:2f:4b:95
>> wlan0_rename: RX AssocResp from 00:19:cb:2f:4b:95 (capab=0x421 status=18
>> aid=0)
>> wlan0_rename: AP denied association (code=18)
>> wlan0_rename: association with AP 00:19:cb:2f:4b:95 timed out
>>
>> Regards
>> Jan-Espen Pettersen
>>
>> Patch url download (if the attachment is unusable or stripped):
>> http://www.radiotube.org/mac80211_emptyext.diff
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
