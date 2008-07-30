Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61244 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbYG3FIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 01:08:09 -0400
Message-ID: <488FF739.5090103@lwfinger.net> (sfid-20080730_070812_860089_27457F52)
Date: Wed, 30 Jul 2008 00:08:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Please do not pull 2.6.27-rc1 into wireless-testing
References: <488E9FB8.3080804@lwfinger.net>	<20080729174623.GA4923@tuxdriver.com> <20080729.214711.244268817.davem@davemloft.net>
In-Reply-To: <20080729.214711.244268817.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Tue, 29 Jul 2008 13:46:23 -0400
> 
>> On Mon, Jul 28, 2008 at 11:42:32PM -0500, Larry Finger wrote:
>>
>>> As stated in the subject, please do not update wireless-testing with 
>>> 2.6.27-rc1, at least for a while. In the thread that starts at  
>>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/18423, I 
>>> found that commit 175f9c1bba9b825d2 breaks wireless, at least for b43. 
>>> Until that is fixed, I think wireless-testing should remain at 2.6.26.
>> Have you tried the patches Johannes sent today?  Do they help the
>> situation?
> 
> And also not keeping wireless-testing at the latest upstream release
> is completely counter productive.
> 
> It's just going to result in more and more merge hassles for John
> than is really reasonable to expect him to deal with just because
> mac80211 has some bug that needs to be fixed.
> 
> And keep in mind that in this particular case, mac80211 has had this
> bug forever, it's just that how the stack is organized now the bug
> matters all the time instead of "sometimes."

I already reported that Johannes's patches worked. It was part of the earlier 
message that seemed to bug you.

I understand that the bug was in mac80211 forever; however, most wireless 
systems worked. With your change in the qdisc handling, essentially no wireless 
worked. If wireless-testing caught the same bug, we would have been "up the creek".

I didn't order John not to pull, I merely asked him. If that would have overly 
complicated his work load, he would either have ignored my request, or he would 
have told me why he couldn't do what I asked. I'm quite certain he would have 
done the latter.

In any case, the matter is now over. The patch that fixes the problem (mostly) 
is in the things that John pushed to you today. Once you do your thing, then 
they will be in mainline too. Until that happens, I have a patch to make 
mainline work for me and I can go on looking for other problems. So far, no new 
ones have appeared. I still get the possible recursive locking warning, but I 
know it is harmless.

Larry
