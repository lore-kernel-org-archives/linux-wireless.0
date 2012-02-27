Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab2B0XZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:25:28 -0500
Subject: Re: [PATCH -iwlwifi] iwlwifi: make tx_cmd_pool kmem cache global
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CANUX_P3JObf0OzAT4L5w7ksry89Ovz2QyAde+DZZUMR6eBt5Hw@mail.gmail.com>
References: <1330350725-5815-1-git-send-email-sgruszka@redhat.com>
	 <1330353016.12612.13.camel@wwguy-huron>
	 <CANUX_P2Xia4HgF_ooUCTRN0+EqX8dx9Wc1rFiDbiNBdgzu9k5Q@mail.gmail.com>
	 <1330364928.12612.15.camel@wwguy-huron>
	 <CANUX_P3JObf0OzAT4L5w7ksry89Ovz2QyAde+DZZUMR6eBt5Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 14:14:16 -0800
Message-ID: <1330380856.12612.20.camel@wwguy-huron> (sfid-20120228_002548_813027_FE43D23E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 22:20 +0200, Emmanuel Grumbach wrote:
> On Mon, Feb 27, 2012 at 19:48, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > On Mon, 2012-02-27 at 19:55 +0200, Emmanuel Grumbach wrote:
> >> I guess that Sanislaw patch is defining one single pool for all the
> >> devices, which means that we won't try to allocate a few pools with
> >> the same name, which leads to this warning.
> >>
> > That I got it, but is really the "only" way to do it, I am really not a
> > fan of global variable.
> >
> I guess we can have a pool for "iwl_dev_cmd_<PCI_DEV_ID>" or something
> like this. But I don't see what is the problem with the global
> variable besides the namespace pollution which is not very problematic
> since we don't export this variable. It is a singleton in terms of
> "Software design pattern" (I hate these buzzwords), and this is the
> way to implement this in C AFAICT.

it is not a problem, just "global" is not something what I prefer, but
it is ok if it is the most easy way to address the problem and not
having side-effect.

Thanks
Wey

