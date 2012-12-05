Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2LEIn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 03:43:56 -0500
Message-ID: <1354697061.9972.2.camel@jlt4.sipsolutions.net> (sfid-20121205_094402_518842_5CA0D161)
Subject: Re: [PATCH v2] mac80211: add debug file for mic failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Dec 2012 09:44:21 +0100
In-Reply-To: <50BEEFA2.8000400@posedge.com>
References: <50BE0606.3000103@posedge.com>
	  <1354633038.9608.3.camel@jlt4.sipsolutions.net>
	  (sfid-20121204_155658_509490_E48BCD66) <1354648076.9608.16.camel@jlt4.sipsolutions.net>
	 <50BEEFA2.8000400@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 12:24 +0530, Saravana wrote:
> On 12/05/2012 12:37 AM, Johannes Berg wrote:
> > On Tue, 2012-12-04 at 15:57 +0100, Johannes Berg wrote:
> >> On Tue, 2012-12-04 at 19:47 +0530, Saravana wrote:
> >>> The mic failure count will provide the number of mic failure that 
> >>> have happened without a countermeasure being started. Once the 
> >>> countermeasure is started, the counter will be reset to 0.
> >>> This count will be helpful when the consecutive 
> >>> mic failure occur at intervals greater than 60 seconds regularly(frequently).
> >>
> >> Applied.
> > 
> > Never mind, dropped. It has a null pointer issue and still has
> 
> could the null pointer issue be prevented by checking 
> the rx->key is valid before update the mic failure? Is it acceptable?
> 
> 	if (rx->key)
> 		rx->key->u.tkip.mic_failures++

Should probably use two labels instead.

> > whitespace issues. Please figure out how to actually indent
> > parameters ...
> > 
> The patch was verified with the checkpatch script. it didn't point out whitespace
> error and the indentation issue.Is there any other scripts that needs to be run additionally?
> Please let me know how to figure out this issue ?

*shrug*, not sure. You've indented the function arguments wrong:

static ssize_t key_mic_failures_read(struct file ...
					size_t count)

you should use spaces there at the end to line up right under "struct",
not only tabs that go too far (or not far enough)

> > Also, signed-off-by should be your full name, is that really just
> > "Saravana"? Your email seems to indicate there's something else
> > ("saravanad")
> > 
> 
> My full name is Saravanakumar and my Father name is Doraiswami. 
> Saravanad, d-indicates my starting letter of my Father name.
> I will probably use Saravanakumar in the future patches..

Hah, sorry. I make this mistake all the time, my bad, I apologise. No
need to do anything differently.

Anyway ... I've fixed it up for you now.

johannes

