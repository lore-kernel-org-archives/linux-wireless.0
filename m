Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58987 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab2FHQYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 12:24:12 -0400
Received: by yenm10 with SMTP id m10so1391071yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 09:24:11 -0700 (PDT)
Message-ID: <4FD22727.7000500@lwfinger.net> (sfid-20120608_182415_948584_8403B5AF)
Date: Fri, 08 Jun 2012 11:24:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andre Heider <a.heider@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?B?TWljaGFlbCBCw7xz?= =?UTF-8?B?Y2g=?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i]
 >= n_queues))
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com> <1339136879.5832.1.camel@jlt3.sipsolutions.net> <1339137689.5832.2.camel@jlt3.sipsolutions.net> <CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com> <1339167160.4901.0.camel@jlt3.sipsolutions.net> <CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com> <1339168452.5748.0.camel@jlt3.sipsolutions.net> <1339168600.5748.2.camel@jlt3.sipsolutions.net> <CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com> <4FD21C6B.5000402@lwfinger.net> <1339170182.5748.7.camel@jlt3.sipsolutions.net> <1339170287.5748.8.camel@jlt3.sipsolutions.net> <1339170510.5748.9.camel@jlt3.sipsolutions.net> <1339170742.5748.10.camel@jlt3.sipsolutions.net> <CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com> <1339171159.5748.11.camel@jlt3.sipsolutions.net> <CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
In-Reply-To: <CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2012 11:05 AM, Andre Heider wrote:
> On Fri, Jun 8, 2012 at 5:59 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Fri, 2012-06-08 at 17:56 +0200, Andre Heider wrote:
>>
>>>> Hopefully this is better: http://p.sipsolutions.net/017d73ac0688f863.txt
>>>
>>> The previous patched all had the mac suspend failure. This one:
>>>
>>> drivers/net/wireless/b43/main.c: In function 'b43_qos_upload_all':
>>> drivers/net/wireless/b43/main.c:3483: error: size of array 'type name'
>>> is negative
>>> drivers/net/wireless/b43/main.c: In function 'b43_qos_clear':
>>> drivers/net/wireless/b43/main.c:3502: error: size of array 'type name'
>>> is negative
>>> drivers/net/wireless/b43/main.c: In function 'b43_op_conf_tx':
>>> drivers/net/wireless/b43/main.c:3578: error: size of array 'type name'
>>> is negative
>>
>> Huh, I thought I compiled it ... guess I had the wrong version.
>>
>> http://p.sipsolutions.net/511dda98892d2c9a.txt
>
> It's getting warmer:
>
> [    9.456216] b43-phy0: Loading OpenSource firmware version 410.31754
> [    9.473798] b43-phy0: Hardware crypto acceleration not supported by firmware
> [    9.491781] b43-phy0: QoS not supported by firmware
> [    9.868750] b43-phy0 debug: Chip initialized
> [    9.888580] b43-phy0 debug: PIO initialized
> [    9.899273] b43-phy0 debug: QoS disabled
> [   10.088420] b43-phy0 debug: Wireless interface started
> [   10.212209] b43-phy0 debug: Adding Interface type 2
> [   12.739776] wlan0: authenticate with d8:5d:4c:9c:31:14
> [   12.796248] wlan0: send auth to d8:5d:4c:9c:31:14 (try 1/3)
> [   12.811768] wlan0: authenticated
> [   12.823310] wlan0: associate with d8:5d:4c:9c:31:14 (try 1/3)
> [   12.844942] wlan0: RX AssocResp from d8:5d:4c:9c:31:14 (capab=0x411
> status=0 aid=2)
> [   12.863966] wlan0: associated
> [   16.319097] ieee80211 phy0: wlan0: No probe response from AP
> d8:5d:4c:9c:31:14 after 500ms, disconnecting.
> [   16.349674] cfg80211: Calling CRDA for country: DE
> [   17.597307] wlan0: authenticate with d8:5d:4c:9c:31:14
> [   17.638399] wlan0: send auth to d8:5d:4c:9c:31:14 (try 1/3)
> [   17.851085] wlan0: send auth to d8:5d:4c:9c:31:14 (try 2/3)
> [   18.063086] wlan0: send auth to d8:5d:4c:9c:31:14 (try 3/3)
> [   18.275081] wlan0: authentication with d8:5d:4c:9c:31:14 timed out
>
> Tried it 3 times, always times out.

Strange. I commented out the BUILD_BUG statements in version 017d73a, and it 
worked for me with both flavors of fw.

Larry

