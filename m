Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:43665 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYC1Ip1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 04:45:27 -0400
Received: by rv-out-0910.google.com with SMTP id k20so71246rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 01:45:26 -0700 (PDT)
Message-ID: <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com> (sfid-20080328_084530_469520_8F5C5E55)
Date: Fri, 28 Mar 2008 10:45:26 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: "Try to stop Tx aggregation on non active TID" messages
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>
In-Reply-To: <1206568750.22530.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1206568750.22530.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> we have a slew of messages saying
>
> [18131.640793] Stop a BA session requested for 00:1a:2a:2c:a2:c5 tid 13
> [18131.640798] Try to stop Tx aggregation on non active TID
>
> just like we had for the RX case before.
>
> Feel free to change the API to allow calling a
> function without as session in progress, but in that case please don't
> print out anything at all.

yes, i noticed that. the prints are coming of course from the MLME
itself that can be called while no session is in progress and checks
the status when called.
i'll do a quick check to decide which way is better (outside check of
the state machine or just a silent discard of non active TIDs
requests) and fix it.
Ron
