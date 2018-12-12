Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68630C04EB8
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 06:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220E42084E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 06:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544596854;
	bh=RkiHTx5MVQrqqDHqmuJ/mFX8rLC+0XQUrdQgLoJuIQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jBp0vMnEbwVRa8AgZm/oKx1nVdLppoEsOFpL3Bv4sc5WRjDCrrWax3IqHhx1KcnzM
	 Y04UAUYV+qnlOmXvoB8189vdf/aq2Lnxo1opTpiqaqhrrpuGaKFxCKo1StHamlSg76
	 3MhD+4auCdXNJHIdXv4dFlLknvIoTT70e3iQkv2I=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 220E42084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbeLLGkx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 01:40:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbeLLGkx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 01:40:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624B82084E;
        Wed, 12 Dec 2018 06:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544596852;
        bh=RkiHTx5MVQrqqDHqmuJ/mFX8rLC+0XQUrdQgLoJuIQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XvJGwxNK6uw9FY0gGJQBB+UJwEwmdh0VxNanYZBaIwxbRhniPVCT0mEEedAkbhuTe
         gaGuuKmskJRla8FDUuKWgxObJmSrM68tzY8VvFOpfCztmrZTSEUxn4s3qETr88F7o5
         rKaT9uWMAD0vopX55uvLraSjeTqcNd9UjUtbSpqA=
Date:   Wed, 12 Dec 2018 01:40:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dietmar May <dmay@intellastar.com>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: wlcore update breaks on 4.9 and 4.4 kernel branches
Message-ID: <20181212064051.GA2746@sasha-vm>
References: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
 <20181202150813.GG221015@sasha-vm>
 <72dcddb8-a44a-d50c-bae6-c51180e53cc8@intellastar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <72dcddb8-a44a-d50c-bae6-c51180e53cc8@intellastar.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 03:29:31PM -0500, Dietmar May wrote:
>Sasha,
>
>I've verified that 4.9.143 no longer exhibits this problem.

Thanks for confirming!

>The revert hasn't shown up in 4.4 yet; but I'll verify once merged there.

There was no 4.4 release yet; it's coming, I promise :)

--
Thanks,
Sasha
