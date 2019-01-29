Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3F9C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 10:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3DF20869
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 10:38:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="IV0h/S5/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="c9yFVCmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfA2Kil (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 05:38:41 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:35103 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbfA2Kil (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 05:38:41 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2019 05:38:40 EST
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id A908917A4;
        Tue, 29 Jan 2019 05:29:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 29 Jan 2019 05:29:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=/4Qhi52VM9EhP6AWEqoVG1sXu2H
        axPDwCX8v59ju3ZI=; b=IV0h/S5/0BLY7DD/+U17yGmFfof1S2Atv1TfUkyAwAt
        0EsYgY/0KwFz00YJicVPCFY7ODiM2D3qvQKA+Oj3tbqrcVJiaylh02/2/a9iIJrL
        wVwkZfS1yPuzr3eu7ZCnzXfssYLtkaahRmPBqOLBkcEM+y1j1X4ZThnZ+ZbPfi48
        lRsntmGyR4ZPZpj+qJh20E1hCX1XT9/qb+saZplXWnq+wKWWEPr2CSDHFczIOWyT
        n+C7PL25G/vKva+fjSaC5X4aNqrA7WapUh89O8U30LwVAfdO3AQE7zYLaE0CozsT
        BSKucbFoJu3mm5mkhHS6sAoTaOAiDnIuXrYN1fPEL1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/4Qhi5
        2VM9EhP6AWEqoVG1sXu2HaxPDwCX8v59ju3ZI=; b=c9yFVCmdXrYt06Is/Kg17v
        2VNJp9Sr+tnbx55T8+LB1Pw+oHz03AahirQAmDWScXq6LH+rUaEpHHXIMQbR3Hmc
        1dFbNjMEXHkTBZSPzg25tbmpoh9/TCHW6mA6oANfNMxUMHPs++zKcQV6e/gorQcg
        FwEkelJyXHhAmtGVnZYocmYuHWgv5VG/vnUVjjSQ0YIiM68T0Ow3WzzbyyS5llfA
        yy3p3aK21mwjaexch6NCP18PDJ+N5tF3LvlFdLYZBHt0h0nNguzZg6KKXGdb1NbO
        1OJ2E0Y3G8ntLWt4NJcFu4SHn0qU9cRF4PQEvweO4wcF3hohpdtUr2hkhPc82Wug
        ==
X-ME-Sender: <xms:_SpQXOyHTCBHffkRNkjRL9xv1Pvxpn7ApYtgv07jJ3UScBd7rOKbUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrjedvgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegoufhprghmkfhpucdlfedttd
    dmnecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnh
    gvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_SpQXPOc0IXlYbby4b6fj_6VkOazupTVhHMs0hY8OTVqvetTaVAMPw>
    <xmx:_SpQXElVWVIA2JQFB0rtcJnqqvtQWgTDSYT1tYXTZgXo5I17Iype4w>
    <xmx:_SpQXEScllEXNgY86PnmQl89MBNTvQR09ssAOXll6TM4DFk9M0oMmw>
    <xmx:_ipQXKGKJ9Z0XQnmlY139h433HC__oZsvYdwsKHgwL45VoZoeBm69gKjWNQ>
Received: from localhost (5356596b.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E727A10315;
        Tue, 29 Jan 2019 05:29:16 -0500 (EST)
Date:   Tue, 29 Jan 2019 11:29:15 +0100
From:   Greg KH <greg@kroah.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
Message-ID: <20190129102915.GE12232@kroah.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 22, 2019 at 01:38:30PM +0100, Stanislaw Gruszka wrote:
> There ware several bugs introduced in 4.20 development cycle
> for mt76x0 driver, that were fixed later but missed 4.20 
> release. This patche set fixes issues for MT7610U and
> MT7630E.
> 
> Bug reference:
> https://bugzilla.kernel.org/show_bug.cgi?id=202243
> 
> Lorenzo Bianconi (1):
>   mt76x0: phy: unify calibration between mt76x0u and mt76x0e
> 
> Stanislaw Gruszka (6):
>   mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
>   mt76x0: use band parameter for LC calibration
>   mt76x02: run calibration after scanning
>   mt76x02: assure we update gain after scan
>   mt76x0: do not perform MCU calibration for MT7630
>   mt76x0: antenna select corrections

Now queued up, thanks.

greg k-h
