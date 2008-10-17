Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59398 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYJQVDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 17:03:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Daiker <daikerjohn@gmail.com>
Subject: Re: [PATCH] b43: reduce checkpatch.pl errors
Date: Fri, 17 Oct 2008 23:02:37 +0200
Cc: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
References: <48F8E479.30304@gmail.com>
In-Reply-To: <48F8E479.30304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810172302.38127.mb@bu3sch.de> (sfid-20081017_230314_102951_B491C367)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 October 2008 21:16:09 John Daiker wrote:
> A few changes to reduce checkpatch.pl errors in the b43 driver.  For the 
> most part, I only fixed cosmetic things, and left the actual 'code flow' 
> untouched (hopefully)!
> 
> Diff is against wireless-testing HEAD.
> 
> Signed-off-by: John Daiker <daikerjohn@gmail.com>
> 
> ---
> 
> 
> 

Looks good, except these:

> -		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
> +		if (1) {
> +			/*FIXME: the last PSpoll frame was sent successfully */

Makes it a lot less obvious what the comment is talking about.
Please leave this untouched.

> -		if (!gphy->aci_enable && 1 /*TODO: not scanning? */ ) {
> -			if (0 /*TODO: bunch of conditions */ ) {
> +		if (!gphy->aci_enable && 1) {
> +			/* TODO: not scanning? */
> +			if (0) {
> +				/*TODO: bunch of conditions */

Same here.

There are probably more of these. I didn't check the whole patch.

> -	//TODO
> +	/* TODO */

Well, that's only generating noise in git and results in merge conflicts
and stuff. I do only use // style comments for temporary comments.
IMO this is OK.

> -char * b43_rfkill_led_name(struct b43_wldev *dev)
> +char *b43_rfkill_led_name(struct b43_wldev *dev)

Well, in my opinion it looks bad to glue the * to the function name.
The pointer * is not related to the function name, but to the return value.

(Note that for variable definitions this is different and I agree that
we should put the * in front of the variable name without spaces)

Well, but I'm not going to create a flamewar for this.
If this is kernel coding style, feel free to change the code.


One additional thing I'd like you to do.
Do a b43 compile before and after applying the patch.
Keep the b43.ko files for both runs and do an md5sum on them.
Add the results to the commit log. The sums _must_ match.
If they don't, please send the changes that change the actual
binary code in seperate patches.

-- 
Greetings Michael.
