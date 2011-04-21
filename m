Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21360 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1DUOQh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 10:16:37 -0400
Subject: Re: [PATCH] iwlwifi: fix possible data overwrite in hcmd callback
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110421071749.GA2203@redhat.com>
References: <1303308178-5297-1-git-send-email-sgruszka@redhat.com>
	 <1303308348.14995.149.camel@wwguy-huron> <20110421071749.GA2203@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 07:13:45 -0700
Message-ID: <1303395225.1507.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 00:17 -0700, Stanislaw Gruszka wrote:

> > Could you elaborate a bit more, why you do not need to protect getting
> > the cmd index.
> 
> get_cmd_index() is simple mathematical function of index local variable
> (provided by firmware) and globally canst q->n_window, not need to be
> protected.
> 
> What need to be protected is iwl_hcdm_queue_reclaim() as is touch
> q->read_ptr and meta->flags to make assure is synchronized across
> different cpus, when new huge command come instantly.
> 
> Note circular queue management could be done lock-less, but need
> trickery described in Documentation/circular-buffers.txt to synchronize
> q->read_ptr and q->write_ptr properly. What is probably too complex to
> be worth to consider instead of simply using a spin lock.
> 
Thanks for the clear, explanation.

Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Wey


