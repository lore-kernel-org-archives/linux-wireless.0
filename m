Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46934 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbdGPLoS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:44:18 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: RFC: Broadcom fmac wireless driver cleanup
Date: Sun, 16 Jul 2017 12:21:08 +0100
Message-Id: <20170716112129.10206-1-ian@mnementh.co.uk> (sfid-20170716_134421_905838_098805B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

I've been doing some cleanups in the broadcome brcmfmac driver, trying to
understand how it works.

I think this makes the driver a *lot* more readable.

Of note:

* Gets rid of the arbitrary and completely 1:1 mapping of
 struct brcmf_{core,chip}_priv/struct brcmf_{core,chip} structures
 which add unreadability whilst offering no real seperation.

* The patch titled HACK - stabilise the value of ->sbwad in use
 highlights an issue that is either bizarre undocumented behaviour or a
 genuine bug - without datasheets, I dont know. Essentially the value of sbwad
 is taken as the base address in several functions, even though it is subject
 to change should other IO occur that moves the window offset

Obviously this is a first cut at this and needs substantial cleanup itself,
however I wanted to get some idea of wether I should continue working on this.

I only have a 43430 SDIO WiFi / BT chip to test on, but other chips *should*
be unaffected by these changes.

-Ian
