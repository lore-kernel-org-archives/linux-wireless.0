Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49148 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZAUHBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 02:01:49 -0500
Received: by bwz14 with SMTP id 14so12109244bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 23:01:47 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwl3945: Use iwl-rfkill
Date: Wed, 21 Jan 2009 08:01:22 +0100
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, Samuel Ortiz <samuel.ortiz@intel.com>,
	linux-wireless@vger.kernel.org
References: <> <1232516035-25524-4-git-send-email-reinette.chatre@intel.com> <1232516035-25524-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1232516035-25524-5-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901210801.23236.helmut.schaa@gmail.com> (sfid-20090121_080205_964531_A64F6390)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Mittwoch, 21. Januar 2009 schrieb Reinette Chatre:
> From: Samuel Ortiz <samuel.ortiz@intel.com>
> 
> Here again, the rfkill routines are duplicated between agn and 3945. Let's
> move the agn one to iwlcore, and so we can get rid of the 3945 ones.

[...]

> +void iwl_bg_rf_kill(struct work_struct *work)
> +{
> +	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
> +
> +	wake_up_interruptible(&priv->wait_command_queue);
> +
> +	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> +		return;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	if (!iwl_is_rfkill(priv)) {
> +		IWL_DEBUG(IWL_DL_RF_KILL,
> +			  "HW and/or SW RF Kill no longer active, restarting "
> +			  "device\n");
> +		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> +			queue_work(priv->workqueue, &priv->restart);

I've changed this check in both rf-kill patches (3945 and agn) to

if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
    test_bit(STATUS_ALIVE, &priv->status))

in order to avoid restarting the adapter when notified about rfkill changes
by interrupt/polling.

I guess this is just an oversight, right?

Thanks,
Helmut
