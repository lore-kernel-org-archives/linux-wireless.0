Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57551 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZEaTCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 15:02:11 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243763887.19302.29.camel@johannes.local>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 31 May 2009 21:01:49 +0200
Message-Id: <1243796509.6570.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > If I read correctly, userspace can write to the global states, but
> > can't read them?  I think it's awkward to implement rfkill-input in
> > userspace without being able to read the global states.  The daemon
> > would have to save the states in a file, in case it is restarted.
> 
> You have a point there, but I'm not sure it even cares? When restarted
> it will probably want to impose its current policy anyway? It would be
> easy to add that we send the global default value for newly added ones
> too but I'm not sure it's necessary -- Marcel?

we can be smart and send an additional CHANGE_ALL when opening the
control device if it is set. We can also just send these anyway. Doesn't
really matter? Does it?

Regards

Marcel


