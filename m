Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755927AbdELNv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 09:51:58 -0400
Received: from potku.adurom.net (a88-114-241-177.elisa-laajakaista.fi [88.114.241.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A14D360A08
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 13:51:56 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: nl80211 vendor commands on upstream drivers
Date: Fri, 12 May 2017 16:51:52 +0300
Message-ID: <87wp9mp4hz.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_155201_855594_38A6052A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

last fall at Wireless Summit at Santa Fe we talked about having nl80211
vendor commands in upstream drivers[1]. The discussion starter was this
wil6210 patch:

wil6210: low level RF sector API
https://patchwork.kernel.org/patch/9403071/

The conclusion from the discussion was that in some (rare) cases having
vendor commands in upstream is acceptable, for example like here when
interfacing low level hw features which most likely is not not
compatible with other designs.

But this does not mean that the gates are open for all possible hacks
via vendor commands, we still want to have generic nl80211 interface for
all normal functionality. Just to give some examples of something which
is NOT acceptable:

* yet another scanning interface (exception maybe being spectral scan?)
* power save settings
* btcoex settings

Comments? Am I forgetting something from the discussion?

[1] https://docs.google.com/document/u/1/d/e/2PACX-1vQXbVQ-3zQt3Bcr3OWfwzbw_C49tTvf0ed8Hmf7b20E6tXc3a40tWZmPku49iGDE-OhgxNmO_lkkHEn/pub

-- 
Kalle Valo
