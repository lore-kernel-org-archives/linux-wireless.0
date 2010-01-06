Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62436 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0AFTO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 14:14:27 -0500
Message-ID: <4B44E10D.7090802@gmail.com>
Date: Wed, 06 Jan 2010 20:14:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: wireless, fix memory leak
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz> <1262795743-15009-2-git-send-email-jslaby@suse.cz> <4B44DF84.80206@gmail.com>
In-Reply-To: <4B44DF84.80206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2010 08:07 PM, Gertjan van Wingerde wrote:
> On 01/06/10 17:35, Jiri Slaby wrote:
>> @@ -717,6 +717,9 @@ int cfg80211_wext_siwscan(struct net_device *dev,
>>   out:
>>  	cfg80211_unlock_rdev(rdev);
>>  	return err;
>> +out_free:
>> +	kfree(creq);
>> +	goto out;
>>  }
>>  EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
>>  
> 
> This last part looks a bit strange. Why don't you put out_free label before out label,

Because `out' is a part of non-error flow, where the creq should not be
freed.

thanks,
-- 
js
