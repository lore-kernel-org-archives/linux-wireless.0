Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2812C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 20:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B54D920848
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 20:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfCAUKX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 15:10:23 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:50779 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfCAUKW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 15:10:22 -0500
Received: from oxbaltgw67.schlund.de ([172.19.246.154]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MvsN5-1hIiuj03JX-00sx5f; Fri, 01 Mar 2019 21:10:18 +0100
Date:   Fri, 1 Mar 2019 21:10:17 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <1125416917.128310.1551471017839@email.ionos.de>
Subject: brcmfmac: bogus error messages during module unload
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev51
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:7SgQ9dz5AZ4iwav/NkPpJ0K9uMldcNl/tzRw+zSNXHCikpAHH6R
 hNGA4Di9dYwBkfWlw+euovcl7llSzdAB7V1wU4Kvw2ydGP6CwDRbYoNKIcAnysj14MadUtI
 DwLtRw0Qq7FKOiSIfT9DieUiVKVO/wnLudbRRXP2v0zm7ysqNYBhg/d8BMfMbhF8kAsrlbd
 RK2c1fydo0DSPAbN0kqEw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Zy2s5kVinQU=:UXZwIFz9UZpkhhQzyQnecj
 zLqd8dWIcHBSP+8zAw7O+//XBHMOfk7ZQUX+u9tfAMMJfKL0WOf0cgMFkof86R4g8GJ4UkyMT
 9ta/1ig6GlJuG4hOdc9GLAPA4tZ+ziw8zbMz8RlIvB8CPoPuGUcqO3LeIYWsfd090Ok9sfQ7n
 gOJh2MIudJJdk4HqZYxIebTIXsMIzY3xOTMgSotU/ImyDBdzTIr3A6UawatGF6/TJjJlMvVDs
 0jRxcN2PFlC4FXs23qGc/LQRd5WGBIXYCtwv1RwjRksAEzm1Lsr/LA1RUr2JeSbla02gBu33y
 OJrWQzis8ZJYsl86YUSxw8uwg2l0gx/tYtMTVtm+MKoO9X8tFsqFehmQknhsEWuugS3s9MmN1
 ooI4x2F3gCyppszgkOVgeJXUNjgpzEECjyoVdGtyGDPRIaXNUJHFaiyr2UZXhg8/X5hh8bjeW
 7KOJ6Y1mFmBtCxh3TkyujWVtX4rSIyA9uszXQMOvBDqzTWqk/qErjkvNpZy7i0sE/NL/uppp3
 Nzm+wbTlvV2huO0L7cOhxmygpymknloNlbjriCPMCFU/bBqXLJY6YStU9C2kakb2CTtai+xME
 u5IA42TrZwhmHNIPrWHQ69GQqdjG6pG95u882ebJ3uFryu8DgKpib2ihgomPUBf0kGheUS3Mr
 NN+L8Ux2rUh5BCVVXolUvo+yvP7dgXrPhYoqmW1VNhh3abJj3bletZ7rqcvq18RIaNZ6zF/Ai
 CL/LqA2gLw2dQv5CA4NVoNO+G1QmiRAZKL/YsGv2NP1P/wPM5fzaQRPLE/U=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

this is some kind of older issue with brcmfmac. Everytime i unload the kernel module (e.g. v5.0-rc8 or next-20190301) on a Raspberry Pi 3 (multi_v7_defconfig / arm64_defconfig) after the driver has successful probed, i'm getting such bogus error messages in the kernel log:

[  870.477114] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -5
[  870.477122] brcmfmac: brcmf_cfg80211_get_tx_power: error (-5)
[  871.057074] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  871.057153] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  871.057870] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  871.057878] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)

Is there a chance to remove or at least reduce them?

Thanks
Stefan
