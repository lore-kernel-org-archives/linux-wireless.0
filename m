Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:43597 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbXIMVmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 17:42:36 -0400
Message-ID: <46E9AECE.5050305@telenet.be>
Date: Thu, 13 Sep 2007 23:42:38 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
References: <46CF95F9.6090802@telenet.be> <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be> <1188211749.6756.11.camel@johannes.berg> <20070831180933.GB3352@tuxdriver.com> <46DB537E.8030801@telenet.be> <1188808692.14564.24.camel@johannes.berg> <46DC1500.7090808@telenet.be> <20070913183918.GA10239@tuxdriver.com>
In-Reply-To: <20070913183918.GA10239@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



John W. Linville wrote:
> On Mon, Sep 03, 2007 at 04:06:56PM +0200, ian wrote:
>> Johannes Berg wrote:
>>> On Mon, 2007-09-03 at 02:21 +0200, ian wrote:
>>>
>>>> we could additionally remove the module_alias from rc80211_simple
>>> indeed, please roll into this patch
>>>
>> I don't know enough from debugfs yet, to do that part, but I'll read up.
>>
>> ---
>> Make rc80211_simple the default rate scaling algorithm
> 
>> @@ -78,11 +78,12 @@ static struct rate_control_ops *
>>  ieee80211_rate_control_ops_get(const char *name)
>>  {
>>  	struct rate_control_ops *ops;
>> +	const char *try_name = name ? name : "simple";
>>
>> -	ops = ieee80211_try_rate_control_ops_get(name);
>> +	ops = ieee80211_try_rate_control_ops_get(try_name);
>>  	if (!ops) {
>> -		request_module("rc80211_%s", name ? name : "default");
>> -		ops = ieee80211_try_rate_control_ops_get(name);
>> +		request_module("rc80211_%s", try_name);
>> +		ops = ieee80211_try_rate_control_ops_get(try_name);
>>  	}
>>  	return ops;
>>  }
>> --- a/net/mac80211/rc80211_simple.c	2007-09-03 15:53:42.000000000 +0200
>> +++ b/net/mac80211/rc80211_simple.c	2007-09-03 15:54:40.000000000 +0200
>> @@ -29,7 +29,6 @@
>>  #define RATE_CONTROL_INTERVAL (HZ / 20)
>>  #define RATE_CONTROL_MIN_TX 10
>>
>> -MODULE_ALIAS("rc80211_default");
>>
>>  static void rate_control_rate_inc(struct ieee80211_local *local,
>>  				  struct sta_info *sta)
>  
> Does this actually change anything?  With the MODULE_ALIAS line
> in rc80211_simple.c, doesn't the request_module("rc80211_default")
> just load rc80211_simple?
> 
> Confused...

I believe it should. :) obviously. I'll Do my best to explain it. It
seems a bit overkill for the I don't know 10 lines it changes.


The main clue is ieee80211_try_rate_control_ops_get never being called with NULL.
not so much the request_module line.

The way it was probably intended:
1) find default
2) if not found load rc80211_default
3) find default

The thing is that there is no way to find "default". There is nothing Except the
module alias(which you can't really check for at runtime? in the list of loaded algos)
that designated a certain algorithm to be default.

To compensate and hide the code's inability to find the default, it just grabbed the first
module that was loaded.

this find default was implemented by this null check
-		if (!name || !strcmp(alg->ops->name, name))
+		if (!strcmp(alg->ops->name, name))

which now serves no more purpose and was hence removed


The idea that a module itself could determine it is the default is probably
broken from a security point of view.

The patch is really trivial, but I believe this is what was meant. I could Just
have let it load rc80211_default. However the logic behind the alias vanished by
(for now) hard coding which rs is the default. Johannes then asked
me to remove the alias all together.

The whole point of this exercise is to make simple the default.

perhaps it would have been clearer if I had changed step 2 and replaced the null_check
with an strcmp for rc80211_simple. But this patch seemed cleanest.

I hope I answered your question.


> 
> John
