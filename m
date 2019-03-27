Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07326C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 01:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB8A02087E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 01:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553651637;
	bh=qFm6xqS6aWDk2U471Dmq7ANR4B9/ETmWfaeKFXjErLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ACpHO6s6Yyf/BAOLBtZZGwQn/1zedsF7LnyDWuka387e1+9rxwHD50bsEIOkIqmgj
	 A0zjxCb9z1b65atVNka5v6v2gH2BRccoZynwuDeUcZV9i/6fLJBuNr+R/tvBx1Ua1x
	 Sa35RBT3zjKtA9tjU9oUUIVZdeA1MAuSNm84Wt1o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732003AbfC0Bxx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 21:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731483AbfC0Bxx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 21:53:53 -0400
Received: from localhost (mobile-166-137-177-030.mycingular.net [166.137.177.30])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D29012087E;
        Wed, 27 Mar 2019 01:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553651631;
        bh=qFm6xqS6aWDk2U471Dmq7ANR4B9/ETmWfaeKFXjErLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhGFyFeoQCZx1mdqu2dREI0FLdmBZw/HBykquxpPwZwCSbUqUVeknUJ/SRu+n6kjD
         GNi1tdRDPL+NK1xn5OdTYSK7GWzcXxiEUdOrjtzp4l0gzWL7hUVaEgcQYWdGSo6wUi
         /O51rEDSEPxeFE9fZJlKLU7N/SKejMnqDvwOlTEM=
Date:   Wed, 27 Mar 2019 10:53:46 +0900
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
Message-ID: <20190327015346.GA17979@kroah.com>
References: <20190122152151.16139-24-gregkh@linuxfoundation.org>
 <03bb68be-8e42-a463-2d57-3be051dc2016@redhat.com>
 <20190327012600.GA3649@kroah.com>
 <5660d50d-6cbf-3b36-6e6c-312b1617ed23@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5660d50d-6cbf-3b36-6e6c-312b1617ed23@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 26, 2019 at 06:47:33PM -0700, Laura Abbott wrote:
> On 3/26/19 6:26 PM, Greg Kroah-Hartman wrote:
> > On Tue, Mar 26, 2019 at 04:55:54PM -0700, Laura Abbott wrote:
> > > On 1/22/19 7:21 AM, Greg Kroah-Hartman wrote:
> > > > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> > > > index 33b0af24a537..c52cdc538678 100644
> > > > --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> > > > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> > > > @@ -1446,9 +1446,8 @@ static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
> > > >    #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
> > > >    	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
> > > >    #define MVM_DEBUGFS_ADD_FILE_VIF(name, parent, mode) do {		\
> > > > -		if (!debugfs_create_file(#name, mode, parent, vif,	\
> > > > -					 &iwl_dbgfs_##name##_ops))	\
> > > > -			goto err;					\
> > > > +		debugfs_create_file(#name, mode, parent, vif,		\
> > > > +				    &iwl_dbgfs_##name##_ops);		\
> > > >    	} while (0)
> > > >    MVM_DEBUGFS_READ_FILE_OPS(mac_params);
> > > > @@ -1483,12 +1482,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
> > > >    	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
> > > > -	if (!mvmvif->dbgfs_dir) {
> > > > -		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
> > > > -			dbgfs_dir);
> > > > -		return;
> > > > -	}
> > > > -
> > > >    	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
> > > >    	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
> > > >    	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p)))
> > > > @@ -1537,12 +1530,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
> > > >    	mvmvif->dbgfs_slink = debugfs_create_symlink(dbgfs_dir->d_name.name,
> > > >    						     mvm->debugfs_dir, buf);
> > > > -	if (!mvmvif->dbgfs_slink)
> > > > -		IWL_ERR(mvm, "Can't create debugfs symbolic link under %pd\n",
> > > > -			dbgfs_dir);
> > > > -	return;
> > > > -err:
> > > > -	IWL_ERR(mvm, "Can't create debugfs entity\n");
> > > >    }
> > > 
> > > Fedora got a bug report https://bugzilla.redhat.com/show_bug.cgi?id=1691034
> > > of a crash with 5.0 and the user did a bisect which pointed to ff9fb72bc077
> > > ("debugfs: return error values, not NULL") because the error checking is
> > > no longer correct in this driver.
> > > 
> > > Based on https://patchwork.kernel.org/patch/10865839/, it looks like
> > > this is supposed to go in for 5.2 but this needs to go in now as
> > > the error checking is currently broken without it. Can this get queued
> > > for Linus so we can get it in 5.0 stable?
> > 
> > That's odd, I can't see how the error checking is wrong here.  If the
> > directory is not created, an error will be returned, which should be
> > able to be handled by debugfs_create_file().
> > 
> > So with this patch does the error go away?
> > 
> 
> The full patch didn't apply cleanly and I didn't try to backport it
> for the reporter to test. I was going off of the theory that if the
> patch was there it would fix the problem.
> 
> What I _think_ is going wrong is dbgfs_dir is actually an errno value:
> 
> 
>         struct dentry *dbgfs_dir = vif->debugfs_dir;
>         struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
>         char buf[100];
> 
>         /*
>          * Check if debugfs directory already exist before creating it.
>          * This may happen when, for example, resetting hw or suspend-resume
>          */
>         if (!dbgfs_dir || mvmvif->dbgfs_dir)
>                 return;
> 
> 
> so this blows up in the snprintf
> 
>         snprintf(buf, 100, "../../../%pd3/%pd",
>                  dbgfs_dir,
>                  mvmvif->dbgfs_dir);

Ah, yeah, that's horrible.  They had the name before, why pull it out of
the dentry again?  That will blow up hard, but maybe printk should check
to see if the pointer really is a pointer first.

> Unless I misunderstood what the debugfs error change did. I think this
> also means the if check needs to look for IS_ERR and not just !dbgfs_dir.

Yes, that is correct.

thanks,

greg k-h
