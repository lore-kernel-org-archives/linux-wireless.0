Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:35730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYJQVgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 17:36:43 -0400
Received: by rv-out-0506.google.com with SMTP id k40so764978rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 14:36:38 -0700 (PDT)
Message-ID: <48F90564.3040301@gmail.com> (sfid-20081017_233647_396102_E293CE5C)
Date: Fri, 17 Oct 2008 14:36:36 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: reduce checkpatch.pl errors
References: <48F8E479.30304@gmail.com> <200810172302.38127.mb@bu3sch.de>
In-Reply-To: <200810172302.38127.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

Thanks for the feedback.  Bob Copeland had mentioned on a different 
patch that I compare the binaries before and after a patch.  I will be 
sure to do this on the patch rework.  Further comments inline.

Michael Buesch wrote:
> On Friday 17 October 2008 21:16:09 John Daiker wrote:
>   
>> A few changes to reduce checkpatch.pl errors in the b43 driver.  For the 
>> most part, I only fixed cosmetic things, and left the actual 'code flow' 
>> untouched (hopefully)!
>>
>> Diff is against wireless-testing HEAD.
>>
>> Signed-off-by: John Daiker <daikerjohn@gmail.com>
>>
>> ---
>>
>>
>>
>>     
>
> Looks good, except these:
>
>   
>> -		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
>> +		if (1) {
>> +			/*FIXME: the last PSpoll frame was sent successfully */
>>     
>
> Makes it a lot less obvious what the comment is talking about.
> Please leave this untouched.
>   
How about this:

-		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
+		if (1) {  /*FIXME: the last PSpoll frame was sent successfully */

or this?

-		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
+		if (1) /*FIXME: the last PSpoll frame was sent successfully */ {


I'm just not a fan of putting the comment inside the if conditional.
Your argument about losing the precise meaning of the comment is 
understood, but I think there is a middleground here. I would hope that 
any 'if (1)' line would immediately raise the 'look for a comment' flag 
in someone's brain. :P
>> -		if (!gphy->aci_enable && 1 /*TODO: not scanning? */ ) {
>> -			if (0 /*TODO: bunch of conditions */ ) {
>> +		if (!gphy->aci_enable && 1) {
>> +			/* TODO: not scanning? */
>> +			if (0) {
>> +				/*TODO: bunch of conditions */
>>     
>
> Same here.
>
> There are probably more of these. I didn't check the whole patch.
>
>   
>> -	//TODO
>> +	/* TODO */
>>     
>
> Well, that's only generating noise in git and results in merge conflicts
> and stuff. I do only use // style comments for temporary comments.
> IMO this is OK.
>   
I'll strip these out of the next patch.  I agree this is a weird rule, 
but checkpatch.pl did all the work.  I'll put more brainpower behind the 
next patch, haha.
>   
>> -char * b43_rfkill_led_name(struct b43_wldev *dev)
>> +char *b43_rfkill_led_name(struct b43_wldev *dev)
>>     
>
> Well, in my opinion it looks bad to glue the * to the function name.
> The pointer * is not related to the function name, but to the return value.
>
> (Note that for variable definitions this is different and I agree that
> we should put the * in front of the variable name without spaces)
>
> Well, but I'm not going to create a flamewar for this.
> If this is kernel coding style, feel free to change the code.
>   
I'm certainly not trying to start a flamewar, either, so thanks for 
keeping the torches at bay! :)  AFAIK, this is accepted (and preferred?) 
kernel style, so it will be included in the updated patch.  At least 
until I see more vigorous pushback.
>
> One additional thing I'd like you to do.
> Do a b43 compile before and after applying the patch.
> Keep the b43.ko files for both runs and do an md5sum on them.
> Add the results to the commit log. The sums _must_ match.
> If they don't, please send the changes that change the actual
> binary code in seperate patches.
>   
Will do this next time with updated patch, among other things.

Thanks,
JD
