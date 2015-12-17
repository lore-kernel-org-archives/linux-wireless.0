Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:59862 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932169AbbLQFTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 00:19:23 -0500
Message-ID: <1450329559.5661.5.camel@perches.com> (sfid-20151217_061927_278308_FC11BCF1)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Joe Perches <joe@perches.com>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: "ola. olsson" <ola.olsson@sonymobile.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	johannes@sipsolutions.net
Date: Wed, 16 Dec 2015 21:19:19 -0800
In-Reply-To: <CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
	 <1450314972.5661.2.camel@perches.com>
	 <CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 05:19 +0100, Ola Olsson wrote:
> Hi Joe,
> 
> > maybe all of these should be a nand b?
> 
> You're right but i don't understand where the problem is. Please help
> me.
> 

The code is currently like:

       WARN_ON(ops->add_station && !ops->del_station);
 
but maybe it should be

	WARN_ON((ops->add_station && !ops->del_station) ||
		(!opt->add_station && ops->del_station))

etc...
