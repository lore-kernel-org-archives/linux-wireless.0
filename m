Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37024 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2FAHJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 03:09:48 -0400
Message-ID: <4FC86AB4.9020602@qca.qualcomm.com> (sfid-20120601_090952_799232_456E05FF)
Date: Fri, 1 Jun 2012 12:39:40 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <stable@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com>	 (sfid-20120601_083956_399882_A3D65832) <1338533070.4884.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338533070.4884.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Friday 01 June 2012 12:14 PM, Johannes Berg wrote:
> On Fri, 2012-06-01 at 12:09 +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> In ath9k we make sure the following two things
>> *if the first interface is ADHOC we cannot have any other interface.
>> *we cannot add an ADHOC interface if there is already an interface
>> is present.
>
>> -	if ((ah->opmode == NL80211_IFTYPE_ADHOC) ||
>> -	    ((vif->type == NL80211_IFTYPE_ADHOC)&&
>> -	     sc->nvifs>  0)) {
>> -		ath_err(common, "Cannot create ADHOC interface when other"
>> -			" interfaces already exist.\n");
>> +	if ((ah->opmode == NL80211_IFTYPE_ADHOC)&&  (sc->nvifs>  0)) {
>> +		ath_err(common, "Cannot create any other interface when an ADHOC interface already exists.\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	if ((vif->type == NL80211_IFTYPE_ADHOC)&&  (sc->nvifs>  0)) {
>> +		ath_err(common, "Cannot create ADHOC interface when other interfaces already exist.\n");
>
> You could just remove the entire check since the interface combinations
> you advertise don't allow it, I think? Or just fix those
> combinations :-)

i did not check this before, thanks a lot for your inputs. will send a 
proper v2 after checking this out.


-- 
thanks,
shafi
