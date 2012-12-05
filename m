Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:40909 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab2LEGyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 01:54:33 -0500
Message-ID: <50BEEFA2.8000400@posedge.com> (sfid-20121205_075437_085075_7CBE207F)
Date: Wed, 05 Dec 2012 12:24:26 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: add debug file for mic failure
References: <50BE0606.3000103@posedge.com>  <1354633038.9608.3.camel@jlt4.sipsolutions.net>  (sfid-20121204_155658_509490_E48BCD66) <1354648076.9608.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354648076.9608.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2012 12:37 AM, Johannes Berg wrote:
> On Tue, 2012-12-04 at 15:57 +0100, Johannes Berg wrote:
>> On Tue, 2012-12-04 at 19:47 +0530, Saravana wrote:
>>> The mic failure count will provide the number of mic failure that 
>>> have happened without a countermeasure being started. Once the 
>>> countermeasure is started, the counter will be reset to 0.
>>> This count will be helpful when the consecutive 
>>> mic failure occur at intervals greater than 60 seconds regularly(frequently).
>>
>> Applied.
> 
> Never mind, dropped. It has a null pointer issue and still has

could the null pointer issue be prevented by checking 
the rx->key is valid before update the mic failure? Is it acceptable?

	if (rx->key)
		rx->key->u.tkip.mic_failures++


> whitespace issues. Please figure out how to actually indent
> parameters ...
> 
The patch was verified with the checkpatch script. it didn't point out whitespace
error and the indentation issue.Is there any other scripts that needs to be run additionally?
Please let me know how to figure out this issue ?

> Also, signed-off-by should be your full name, is that really just
> "Saravana"? Your email seems to indicate there's something else
> ("saravanad")
> 

My full name is Saravanakumar and my Father name is Doraiswami. 
Saravanad, d-indicates my starting letter of my Father name.
I will probably use Saravanakumar in the future patches..

> johannes
> 
> 

