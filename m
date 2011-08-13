Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53254 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab1HMVpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 17:45:40 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QsM1O-0001BK-Gy
	for linux-wireless@vger.kernel.org; Sat, 13 Aug 2011 23:45:34 +0200
Message-ID: <4E46F073.5020503@fastmail.fm> (sfid-20110813_234545_570709_B0E6311A)
Date: Sat, 13 Aug 2011 23:45:23 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
MIME-Version: 1.0
To: Christian Lamparter
	<public-chunkeey-gM/Ye1E23mwN+BqQ9rBEUg@plane.gmane.org>
CC: Bernd Schubert
	<public-bernd.schubert-97jfqw80gc6171pxa8y+qA@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	"Luis R. Rodriguez"
	<public-mcgrof-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
Subject: Re: carl9170 does not like all frequencies
References: <j26l8a$ea9$1@dough.gmane.org> <201108132234.16886.chunkeey@googlemail.com> <4E46E3C5.5060403@fastmail.fm> <201108132311.46792.chunkeey@googlemail.com>
In-Reply-To: <201108132311.46792.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>>>>> [ 1058.936551] cfg80211: Calling CRDA to update world regulatory domain
>>>>> [ 1058.945510] cfg80211: World regulatory domain updated:
>>>>> [ 1058.945519] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>>>> [ 1058.945529] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>>>> [ 1058.945538] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>>>> [ 1058.945547] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>>>> [ 1058.945555] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>>>> [ 1058.945563] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>>>> [ 1058.945604] cfg80211: Calling CRDA for country: 97
>>>>> [ 1061.373997] ieee80211 phy1: channel change: 2417 -> 2422 failed (2).
>>>>> [ 1061.682115] ieee80211 phy1: channel change: -1 -> 2422 failed (2).
>>>>> [ 1061.682132] usb 10-1.2: restart device (7)
>>>>> [ 1062.096523] cfg80211: Calling CRDA to update world regulatory domain
>>>>> [ 1062.105469] cfg80211: World regulatory domain updated:
>>>>
>>>> Any idea what is going on here? Do I need a crda tool? Or is something
>>>> else failing?
>>> Yes, you need crda, if you haven't installed it already.
>>
>> Sorry, I forgot "update" there. So I asked if I would need to update
>> crda. I just did that, but I just don't want to disconnect right now to
>> see if it connects any faster. Those messages still appear every 16
>> seconds and spam my logs :(
> Luis, do you know what causes these CRDA spamming?
> (Also, the country code should be "DE" in his case, or?)

After installing a new crda version *and* rebooting those messages only
appear once now. New 3.1-rc1 kernel incompatible with old tools?

Btw, isn't errno=28 a bit weird on setting the country code with crda?


bernd@bathl ~>COUNTRY=DE crda
Failed to set regulatory domain: -28

(28 = ENOSPC)


Thanks,
Bernd

