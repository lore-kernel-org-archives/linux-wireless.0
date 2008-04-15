Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:57687 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYDOPzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 11:55:20 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1115004wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 08:55:19 -0700 (PDT)
Message-ID: <1ba2fa240804150855p11778d35i92c83def49a1b9c8@mail.gmail.com> (sfid-20080415_165526_228360_3B75D293)
Date: Tue, 15 Apr 2008 18:55:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1208255742.3502.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200804051931.58895.IvDoorn@gmail.com>
	 <200804141827.50991.IvDoorn@gmail.com>
	 <1ba2fa240804141139ua5f6f26k6920001ceb59443e@mail.gmail.com>
	 <200804142307.48550.IvDoorn@gmail.com>
	 <1208255742.3502.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 15, 2008 at 1:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > > Not sure what was intention for hw_key_idx but currently there are assignment
>  > > from key->conf.keyidx to hw_key_idx and visa versa.  keyidx is used
>  > > for 802.11 key index [1..4]
>  > > So it's quit risky to use it for something else
>  >
>  > That souds like a bug in mac80211 then. hw_key_idx is for internal use for the driver,
>  > and mac80211 should never expect the driver to set it to a particular value.
>
>  Yeah, that'd be a bug, and I can't find any such assignment. In fact,
>  mac80211 doesn't contain any assignment to hw_key_idx or to a 1-4
>  key_idx from hw_key_idx. Never mind the fact that the tx_control member
>  could be called hw_key_idx as well...
>
Sorry my mistake I get confused by a bug from past. It was bug in
iwlwifi not in mac80211. mac80211 looks OK.

Tomas
