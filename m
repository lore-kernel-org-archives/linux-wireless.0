Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:64125 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbXBSOL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 09:11:59 -0500
Received: by nf-out-0910.google.com with SMTP id o25so2432708nfa
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2007 06:11:58 -0800 (PST)
Message-ID: <a32f33a40702190611k539b6974ka739fc31c8dab00e@mail.gmail.com>
Date: Mon, 19 Feb 2007 15:11:57 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] rt2x00: fix memory corruption caused by eeprom buffer overflow
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1171893099.8550.23.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070219024654.3480.9392.stgit@dl.roinet.com>
	 <a32f33a40702190307x2861b654s6233a6b9858e8233@mail.gmail.com>
	 <1171893099.8550.23.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Shame on me.  I wrote a patch that worked on rt61, and then I discarded
> it to make a "clean" fix for all drivers.
>
> But anyway, I'm seeing now that CVS on sourceforge.net is not abandoned,
> so I think the best approach would be to integrate it into the kernel.
> It would be great if you remove dead code from CVS, all those
> "experimental" branches that haven't been touched for months if not
> years.  It was hard for me to find the actual sources.  I would have
> spent last Sunday evening doing something more interesting than fixing
> fixed bugs :)

True true, everything useful is in the "source" module of the CVS tree.
Along with the legacy drivers for each chipset.
I thought the other older tree was already removed... :(

> Finally, I'll appreciate if the driver is fixed to compile against
> wireless-dev kernels.  You can take an approach similar to iwlwifi and
> even rely on the same d80211 package.

Well the d80211 stack inside rt2x00 is slightly modified to contain
compatibility
fixes for regular kernels. That way regular users can test rt2x00,
which is extremely helpful.
Other than that the stack also contains small patches that are in
testing and I am sending
to the wireless list when it is stable. At this moment I have for
example the sequence
counter patch that is currently under discussion on this list, as well
as the currently
antenna patch that will split antenna_sel into a RX and TX antenna selection.

Ivo
