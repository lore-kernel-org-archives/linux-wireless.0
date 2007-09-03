Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:41757 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbXICAWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2007 20:22:06 -0400
Received: from astra.telenet-ops.be (astra.telenet-ops.be [195.130.132.58])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id C39039D1DE
	for <linux-wireless@vger.kernel.org>; Mon,  3 Sep 2007 02:21:57 +0200 (CEST)
Message-ID: <46DB537E.8030801@telenet.be>
Date: Mon, 03 Sep 2007 02:21:18 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
References: <46CF95F9.6090802@telenet.be> <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be> <1188211749.6756.11.camel@johannes.berg> <20070831180933.GB3352@tuxdriver.com>
In-Reply-To: <20070831180933.GB3352@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



John W. Linville wrote:
> On Mon, Aug 27, 2007 at 12:49:09PM +0200, Johannes Berg wrote:
>> On Sat, 2007-08-25 at 14:15 +0200, ian wrote:
>>
>>> I reread the discussion carefully and can't find any specific
>>> comments on the patch which for clarity I will reproduce below.
>> Then I guess I remember wrong and the comment was raised in another
>> thread. The problem we have is that once any rate control algorithm is
>> loaded, it will be default for any future drivers, which is often
>> inappropriate. Hence, it would be great if
>> hw->preferred_rate_control==NULL would indicate "use default" where
>> "default" would be set to "simple" to start with but also changeable.
>> (although the change functionality could just be not usable from
>> userspace for now)
> 
> I ACK this approach.  Anyone have a patch hacked-up to post?
> 

I read up on the code and kernel mechanisms involved and this is
what i came up with

Right now there is no way of knowing what the "default" rc should be
other than that it has a module alias rc80211_default, checking
for this is probably not done, and would be pretty unpractical.
And it wouldn't be settable from userspace in the future either.

We could however replace "simple" with a user settable variable.
(global variable in ieee80211.c like the rate_ctrl_algs and mutex,
with some accessors for a module parameter/debugfs/..?)

we could additionally remove the module_alias from rc80211_simple

I don't know too much of the rest of mac80211 code and conventions,
so feel free to be brutal if this patch makes no sense.
---
Make rc80211_simple the default rate scaling algorithm

Signed-of-by: Ian Schram <ischram@telenet.be>
--- a/net/mac80211/ieee80211_rate.c	2007-09-03 01:26:18.000000000 +0200
+++ b/net/mac80211/ieee80211_rate.c	2007-09-03 01:46:54.000000000 +0200
@@ -62,7 +62,7 @@ ieee80211_try_rate_control_ops_get(const

 	mutex_lock(&rate_ctrl_mutex);
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
-		if (!name || !strcmp(alg->ops->name, name))
+		if (!strcmp(alg->ops->name, name))
 			if (try_module_get(alg->ops->module)) {
 				ops = alg->ops;
 				break;
@@ -78,11 +78,12 @@ static struct rate_control_ops *
 ieee80211_rate_control_ops_get(const char *name)
 {
 	struct rate_control_ops *ops;
+	const char *try_name = name ? name : "simple";

-	ops = ieee80211_try_rate_control_ops_get(name);
+	ops = ieee80211_try_rate_control_ops_get(try_name);
 	if (!ops) {
-		request_module("rc80211_%s", name ? name : "default");
-		ops = ieee80211_try_rate_control_ops_get(name);
+		request_module("rc80211_%s", try_name);
+		ops = ieee80211_try_rate_control_ops_get(try_name);
 	}
 	return ops;
 }


