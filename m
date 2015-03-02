Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49345 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbbCBJZY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 04:25:24 -0500
Message-ID: <1425288321.1906.1.camel@sipsolutions.net> (sfid-20150302_102528_687526_002063DE)
Subject: Re: [PATCH 2/3] ath10k: always save/restore pci config space
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 02 Mar 2015 10:25:21 +0100
In-Reply-To: <CA+BoTQnrS74yx=V_sPvTgzkoZeWbOBFawqXZMAv6oEhUypmoQA@mail.gmail.com> (sfid-20150302_102353_670558_FAE3DCBD)
References: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
	 <1425287344-30594-2-git-send-email-michal.kazior@tieto.com>
	 <1425287785.1906.0.camel@sipsolutions.net>
	 <CA+BoTQnrS74yx=V_sPvTgzkoZeWbOBFawqXZMAv6oEhUypmoQA@mail.gmail.com>
	 (sfid-20150302_102353_670558_FAE3DCBD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-02 at 10:23 +0100, Michal Kazior wrote:

> > I believe the whole thing isn't necessary at all since the kernel's PCIe
> > layer will take care of it.
> 
> You mean only the pci_save_state() and pci_disable_device() or, the
> resume counterpart as well? Hmm.

Resume as well - but I believe it's all-or-nothing.

> Earlier the resume counterpart didn't do any restore stuff and the
> device ended up pretty confused..

which may explain this.

johannes

