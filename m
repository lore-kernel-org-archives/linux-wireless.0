Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep27-int.chello.at ([62.179.121.47]:63891 "EHLO
	viefep27-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYIOIbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 04:31:55 -0400
Received: from gollum.odi.ch ([84.74.148.76]) by viefep27-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080915083151.BWTH184.viefep27-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Mon, 15 Sep 2008 10:31:51 +0200
Received: from [10.11.1.201] (cvs.logobject.ch [81.7.230.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id D25B2235A17
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 10:31:50 +0200 (CEST)
Message-ID: <48CE1D67.8010802@odi.ch> (sfid-20080915_103158_093638_233F5931)
Date: Mon, 15 Sep 2008 10:31:35 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: WEP and enc restricted
References: <48CD314C.40105@odi.ch> <1221456248.27102.43.camel@localhost.localdomain>
In-Reply-To: <1221456248.27102.43.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> It looks like ieee80211_rx_mgmt_auth() in mlme.c should be cycling
> through the various auth methods when it gets an "auth not supported"
> response from the AP.  I wonder why that's not working in your case.
> Can you put some printks in there and see if that code gets triggered
> and if not, poke around a bit to see why?

Yes, I've seen that. I'll have to check the packet log again, but as far as I
remember the AP doesn't respond at all to these authentication packets. So the
cycling will never happen.

> It looks like it does get set from the SIWAUTH handler if you pass in
> the right auth algs bits; but you're correct in that SIWENCODE won't set
> the auth alg.  The patch seems to be correct.

In SIWAUTH only the available algorithms are set, not the actual one. It's a
different variable:
  sdata->u.sta.auth_alg*s* = data->value;

> However, the submission format needs a few things

I'll resend the patch in the correct format.

Cheers

Ortwin

