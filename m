Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61783 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1HIJCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:02:10 -0400
Received: by vws1 with SMTP id 1so4048513vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:02:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312810557.4372.34.camel@jlt3.sipsolutions.net>
References: <1311715772-8855-1-git-send-email-guy@wizery.com>
	<1312810557.4372.34.camel@jlt3.sipsolutions.net>
Date: Tue, 9 Aug 2011 12:02:09 +0300
Message-ID: <CAA03845KXcfSCrrkF2Nt2YUcmisTb2NJZrzHeDA+xx9zmNmc8Q@mail.gmail.com> (sfid-20110809_110215_731456_2D1B91CF)
Subject: Re: [PATCH 1/2] mac80211: refactor sta_info_insert_rcu to 3 main stages
From: Guy Eilam <guy@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 4:35 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Just a cursory look, I'll send a more detailed review later, but I
> wanted to ask John to not merge this for now;
>
>> +static int sta_info_insert_adhoc(struct sta_info *sta) __acquires(RCU)
>
> _ibss would be preferred
>
>> +static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
>
> _mgd is terribly misleading, this will be done for all modes other than
> IBSS.

Fair enough. the _ibss change is logical and understood.
The problem with the _mgd function is that it will be silly to call it
_non_ibss (or is it?)
Do you have a suggestion for a better name?

>
> johannes
>
>
>
