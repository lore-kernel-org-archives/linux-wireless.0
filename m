Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B575C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 01:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C202075E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553649978;
	bh=RVeyg6DNUR+HpppdhLbupgpC87HzZUd2VQtAD3qicHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RGQ8lmiowY34j14AEhKEnQ4EvaY+p6DZoZeo9HVomJZWz8/oAY2QdqWBzPnYG8a6d
	 eITc45voYSxVypUAgMmI0IUYxA15YepreDJMMdoDWxAszLw1ssngwVSnnjIGCqyU09
	 wKoN1W7oL3n37nNJ0Mz0GYyCO/tvxpmDmhtZl/y8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbfC0B0G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 21:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfC0B0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 21:26:06 -0400
Received: from localhost (mobile-166-137-177-030.mycingular.net [166.137.177.30])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DBA2075E;
        Wed, 27 Mar 2019 01:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553649965;
        bh=RVeyg6DNUR+HpppdhLbupgpC87HzZUd2VQtAD3qicHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fK5DYAxHynuEk+3IZ4FBoAkLRTUnVZf6iLJXhZfT1mOxKaLkXyzpHHDm1D8Qkab3k
         SknSo9N88ZdrKi3TFoPmqYQ8RMETsFKS0dNIe1VVlXcwJuxIKiByYJPdPaUYIJFmL0
         QKYYkQclgKnlNAOkS00cqvO1AHcVd4nRFY99QzH4=
Date:   Wed, 27 Mar 2019 10:26:00 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Laura Abbott <labbott@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mvm: no need to check return value of
 debugfs_create functions
Message-ID: <20190327012600.GA3649@kroah.com>
References: <20190122152151.16139-24-gregkh@linuxfoundation.org>
 <03bb68be-8e42-a463-2d57-3be051dc2016@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03bb68be-8e42-a463-2d57-3be051dc2016@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 26, 2019 at 04:55:54PM -0700, Laura Abbott wrote:
> On 1/22/19 7:21 AM, Greg Kroah-Hartman wrote:
> > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> > index 33b0af24a537..c52cdc538678 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> > @@ -1446,9 +1446,8 @@ static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
> >   #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
> >   	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
> >   #define MVM_DEBUGFS_ADD_FILE_VIF(name, parent, mode) do {		\
> > -		if (!debugfs_create_file(#name, mode, parent, vif,	\
> > -					 &iwl_dbgfs_##name##_ops))	\
> > -			goto err;					\
> > +		debugfs_create_file(#name, mode, parent, vif,		\
> > +				    &iwl_dbgfs_##name##_ops);		\
> >   	} while (0)
> >   MVM_DEBUGFS_READ_FILE_OPS(mac_params);
> > @@ -1483,12 +1482,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
> >   	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
> > -	if (!mvmvif->dbgfs_dir) {
> > -		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
> > -			dbgfs_dir);
> > -		return;
> > -	}
> > -
> >   	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
> >   	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
> >   	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p)))
> > @@ -1537,12 +1530,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
> >   	mvmvif->dbgfs_slink = debugfs_create_symlink(dbgfs_dir->d_name.name,
> >   						     mvm->debugfs_dir, buf);
> > -	if (!mvmvif->dbgfs_slink)
> > -		IWL_ERR(mvm, "Can't create debugfs symbolic link under %pd\n",
> > -			dbgfs_dir);
> > -	return;
> > -err:
> > -	IWL_ERR(mvm, "Can't create debugfs entity\n");
> >   }
> 
> Fedora got a bug report https://bugzilla.redhat.com/show_bug.cgi?id=1691034
> of a crash with 5.0 and the user did a bisect which pointed to ff9fb72bc077
> ("debugfs: return error values, not NULL") because the error checking is
> no longer correct in this driver.
> 
> Based on https://patchwork.kernel.org/patch/10865839/, it looks like
> this is supposed to go in for 5.2 but this needs to go in now as
> the error checking is currently broken without it. Can this get queued
> for Linus so we can get it in 5.0 stable?

That's odd, I can't see how the error checking is wrong here.  If the
directory is not created, an error will be returned, which should be
able to be handled by debugfs_create_file().

So with this patch does the error go away?

strange,

greg k-h
