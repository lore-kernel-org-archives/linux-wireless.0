Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99643C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 11:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3860F2173C
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 11:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="cK1FTq/M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfBRLak (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 06:30:40 -0500
Received: from smtpcmd02101.aruba.it ([62.149.158.101]:59067 "EHLO
        smtpcmd02101.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfBRLaj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 06:30:39 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2019 06:30:39 EST
Received: from [192.168.12.18] ([109.168.86.18])
        by smtpcmd02.ad.aruba.it with bizsmtp
        id eBPV1z00P0PkPeM01BPVzn; Mon, 18 Feb 2019 12:23:29 +0100
To:     linux-wireless@vger.kernel.org
From:   Francesco Chiechi - Colibre <francesco.chiechi@colibre.it>
Subject: brcmfmac auto channel selection
Message-ID: <8f5e6db1-d6e1-309e-d5c2-4a737efc2929@colibre.it>
Date:   Mon, 18 Feb 2019 12:23:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aruba.it; s=a1;
        t=1550489009; bh=m9v1ptNygXwkJ6cHDz6ah2l2ToOgjg4k80+hwOYlRz8=;
        h=To:From:Subject:Date:MIME-Version:Content-Type;
        b=cK1FTq/MrrrKlMq81aD6KkhycJ/tneJcBli7wkbiJcaKfvMxjguKYOAdtfryszId0
         NYaNlEbHhClM/HkyQSJ4lLNV3+WHPoj9ElPd7xXRl7SNWk5ixvxsaZZ3k4bmcEI02M
         lcAOWq/PiA9nRwPlGpGpnOFiQiInQQuY6XdAszp1tQC5qfdlEq+NwgYIWNVRw5vDm7
         yTqm12LeBJ4HWC6TurqPfUKoPqanyqGb48Zdq85rTZLXWXzO6vowIO0OdcOk1NQLME
         8QLp280vylBwghFTxFZpY/h8MD6oaGdyPiDTjNsDGW9wl3jiXJu/jHrg4y4tL/8Vy0
         ymz7HLYwQhTaA==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

hello everybody,

I need to implement Auto Channel Selection for the brcmfmac driver.
The chip I'm working on is a CYW43455 (BCM43455).
If I understand it correctly, user space needs the dump_survey
function to be supported in cfg80211_ops (The corresponding android
driver supports it under the configuration option WL_SUPPORT_ACS).

Some questions then:
- is there any technical reason why the dump_survey function is not
  already implemented in brcmfmac?
- it looks like that at a minimum SURVEY_INFO_NOISE_DBM should be
  returned into the survey_info struct. Does anybody have any hint
  on how to get this value, perhaps by using a brcmf_fil_xxx_yyy_get
  function with BRCMF_C_GET_PHY_NOISE?

thank you very much

Francesco
