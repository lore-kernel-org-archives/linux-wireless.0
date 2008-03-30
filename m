Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:38543 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbYC3L42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 07:56:28 -0400
Received: by rv-out-0910.google.com with SMTP id k20so612386rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 04:56:27 -0700 (PDT)
Message-ID: <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com> (sfid-20080330_125641_033279_D50ED97F)
Date: Sun, 30 Mar 2008 14:56:27 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: "Try to stop Tx aggregation on non active TID" messages
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>
In-Reply-To: <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1206568750.22530.8.camel@johannes.berg>
	 <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > we have a slew of messages saying
> >
> > [18131.640793] Stop a BA session requested for 00:1a:2a:2c:a2:c5 tid 13
> > [18131.640798] Try to stop Tx aggregation on non active TID
> >
> > just like we had for the RX case before.
> >
> > Feel free to change the API to allow calling a
> > function without as session in progress, but in that case please don't
> > print out anything at all.
>
> yes, i noticed that. the prints are coming of course from the MLME
> itself that can be called while no session is in progress and checks
> the status when called.
> i'll do a quick check to decide which way is better (outside check of
> the state machine or just a silent discard of non active TIDs
> requests) and fix it.
> Ron

ok, i checked it. i think it is the same as the Rx issue we had. those
prints can be eliminated by .config file's MAC80211_HT_DEBUG. if we
don't use this flag what's the use of it? if we do use it, i would
like to insert the Rx prints back as well.
Ron
