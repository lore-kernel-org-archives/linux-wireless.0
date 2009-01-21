Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbZAUOrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 09:47:10 -0500
Date: Wed, 21 Jan 2009 15:49:36 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwl3945: Use iwl-rfkill
Message-ID: <20090121144931.GB3459@sortiz.org> (sfid-20090121_154715_398200_CA358F31)
References: <1232516035-25524-4-git-send-email-reinette.chatre@intel.com> <1232516035-25524-5-git-send-email-reinette.chatre@intel.com> <200901210801.23236.helmut.schaa@gmail.com>
MIME-Version: 1.0
In-Reply-To: <200901210801.23236.helmut.schaa@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

On Wed, Jan 21, 2009 at 12:01:22AM -0700, Helmut Schaa wrote:
> Hi,
> 
> Am Mittwoch, 21. Januar 2009 schrieb Reinette Chatre:
> > From: Samuel Ortiz <samuel.ortiz@intel.com>
> >
> > Here again, the rfkill routines are duplicated between agn and 3945. Let's
> > move the agn one to iwlcore, and so we can get rid of the 3945 ones.
> 
> [...]
> 
> > +void iwl_bg_rf_kill(struct work_struct *work)
> > +{
> > +     struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
> > +
> > +     wake_up_interruptible(&priv->wait_command_queue);
> > +
> > +     if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> > +             return;
> > +
> > +     mutex_lock(&priv->mutex);
> > +
> > +     if (!iwl_is_rfkill(priv)) {
> > +             IWL_DEBUG(IWL_DL_RF_KILL,
> > +                       "HW and/or SW RF Kill no longer active, restarting "
> > +                       "device\n");
> > +             if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> > +                     queue_work(priv->workqueue, &priv->restart);
> 
> I've changed this check in both rf-kill patches (3945 and agn) to
> 
> if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
>     test_bit(STATUS_ALIVE, &priv->status))
> 
> in order to avoid restarting the adapter when notified about rfkill changes
> by interrupt/polling.
> 
> I guess this is just an oversight, right?
Good catch. It is an oversight, yes.
John, Reinette, do you want a new version of this patch or an additional one
on top of wireless-testing ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

