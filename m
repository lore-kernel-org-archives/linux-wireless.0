Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43591 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbXFKP1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 11:27:31 -0400
Message-ID: <466D69E0.7020204@warmcat.com>
Date: Mon, 11 Jun 2007 16:27:28 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH Try#8 3/4] cfg80211: Radiotap parser
References: <20070611095400.206844675@warmcat.com>	 <20070611095846.511945296@warmcat.com> <1181560668.29767.8.camel@johannes.berg>
In-Reply-To: <1181560668.29767.8.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

Hi Johannes -

>> + * care of alignment handling and extended present fields.  interator->this_arg
> 
> typo: "interator", also I don't understand why you would want to change
> this_arg?

Thanks for the comments which I addressed in try #9.

iterator->this_arg can make sense to increment when you are walking
through one of the compound arguments, like the channel one, the comment
means you don't have to take care to preserve it during the processing
of any argument in your loop.

I did move the function comments into cfg80211 but I didn't prefer it
and when I read Randy's take I moved them back.

-Andy
