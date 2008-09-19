Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37362 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbYISQNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 12:13:53 -0400
Message-ID: <48D3CFBC.6070504@lwfinger.net> (sfid-20080919_181358_599633_39313A91)
Date: Fri, 19 Sep 2008 11:13:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Celejar <celejar@gmail.com>
CC: bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: Can't connect to AP with hidden essid with 2.6.27-rc6
References: <20080916220904.75283811.celejar@gmail.com>	<48D06B9E.70307@lwfinger.net>	<20080918004509.23a4bdc9.celejar@gmail.com>	<48D1E42C.70904@lwfinger.net>	<20080918015202.8c5f6381.celejar@gmail.com>	<48D24911.80101@lwfinger.net>	<20080918160957.94ea063d.celejar@gmail.com>	<48D2D728.6070105@lwfinger.net> <20080919001050.d9ed273a.celejar@gmail.com>
In-Reply-To: <20080919001050.d9ed273a.celejar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Celejar wrote:
> On Thu, 18 Sep 2008 17:33:12 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> Celejar wrote:
>>> Okay, I built and installed CRDA, and I now get:
>>>
>>> Band 1:
>>>         Frequencies:
>>>                 * 2412 MHz
>>>                 * 2417 MHz
>>>                 * 2422 MHz
>>>                 * 2427 MHz
>>>                 * 2432 MHz
>>>                 * 2437 MHz
>>>                 * 2442 MHz
>>>                 * 2447 MHz
>>>                 * 2452 MHz
>>>                 * 2457 MHz
>>>                 * 2462 MHz
>>>                 * 2467 MHz (disabled)
>>>                 * 2472 MHz (disabled)
>>>                 * 2484 MHz (disabled)
>>>
>>> [This is also what I get with an earlier kernel.]
>>>
>>> But the card *still* won't associate with the hidden essid AP; is there
>>> anything else I need to do after 'make, make install' CRDA?
>> No, with this output, you have definitely connected with CRDA. Now
>> that you have CRDA working, I think you may have to bisect again.
>> Certainly, the passive scanning would have made it difficult, if not
>> impossible, to connect to a hidden essid. As you say, you now have the
>> same channel listing as you had with the earlier kernel, thus your
>> bisection may converge on a different patch. Fortunately, it shouldn't
>> take too long. You can go a couple of patches earlier than the
>> regulatory change with a 'git bisect good dbcabfe1a5cfa192e'.
>>
>> Another option would be to uninstall CRDA by deleting /sbin/crda and
>> setting the CONFIG_WIRELESS_OLD_REGULATORY variable to y. At that
>> point, everything should be exactly as in the kernels prior to
>> adopting CRDA.
> 
> This works fine, so I'm happy.  If a bisection will help the devs,
> though, I'll be glad to do it.

I do not think a bisection is necessary. Your successful test of the
old regulatory code suggests to me that there is some kind of problem
with the CRDA database.

Luis - to fill you in, he can connect to an AP with a hidden essid
using the old regulatory code, but not using CRDA. There seems to be
some critical difference between them.

Thanks,

Larry


