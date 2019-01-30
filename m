Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A7CC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3110F20882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AIwI0Z4H";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VHD8Vamy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfA3LKE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:10:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3LKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:10:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8E9B0609E2; Wed, 30 Jan 2019 11:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548846602;
        bh=m0msHh3OSEYuAdtA3Ma87d4ujboGatpZWNoVMekBBLc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AIwI0Z4HdBr58ugEgMqunPmIKNokQ1yZud6L3iWbeqN3bAAiFB++FkXIcJG2sXobi
         3Gz7j55OTdr/U/DUI8qcZeyHured+kjQuX/DNkIuqNpb9tPr1CtHmEvgqAta4Fz/gf
         tu+Rih2mNHF6SeLeGlIV+Mjp8c/o0MeFmf+7XnuU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A830260986;
        Wed, 30 Jan 2019 11:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548846601;
        bh=m0msHh3OSEYuAdtA3Ma87d4ujboGatpZWNoVMekBBLc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VHD8VamygRAFG8B59iHp4N/kyrXvVlvnx1mp730Lnz/H/FoEpLGY7SJCiJEkKlWNj
         ohYmnTHlM8t0Tubh/ZKfP+q48GmxJa9l9nwLPN0/hgZCYaR3Pjvxh4/POUoQRMlkmP
         eTpX/mlIfZALYuGs9evLNr+ml33aBboTST0Rc4UA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A830260986
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-01-29
References: <7e68c48a5c59b164a28d434765b03cba6243c12f.camel@coelho.fi>
Date:   Wed, 30 Jan 2019 13:09:57 +0200
In-Reply-To: <7e68c48a5c59b164a28d434765b03cba6243c12f.camel@coelho.fi> (Luca
        Coelho's message of "Tue, 29 Jan 2019 16:19:01 +0200")
Message-ID: <87lg32jta2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the second batch of patches intended for v5.1.  This includes
> the last two patchsets I sent.  Usual development work.  More details
> about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 64e2330580fbbfa7077ef2f608555f07e0bb4956:
>
>   Merge tag 'iwlwifi-next-for-kalle-2019-01-25' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-01-29 14:56:05 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-01-29
>
> for you to fetch changes up to 01f377dc927da6e42cbffb00fc8d431c8341da3f:
>
>   iwiwifi: fix bad monitor buffer register addresses (2019-01-29 16:10:33 +0200)
>
> ----------------------------------------------------------------
> Second batch of iwlwifi patches intended for v5.1
>
> * A bunch of fixes for issues found with static analyzers;
> * Relicense the pcie submodule to dual GPL/BSD;
> * Reworked the TOF/CSI implementation;
> * Work on new debugging infra continues;
> * Some product name updates in the human-readable strings
> * Some more cleanups for the device configuration refactoring;
> * General bugfixes;
> * Other cleanups and small fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

Oh, but I see a new warning:

drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning: 'iwl_mvm_add_rtap_sniffer_config' defined but not used [-Wunused-function]
 static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Can you send separately a patch to fix this so that I can apply it
directly?

-- 
Kalle Valo
