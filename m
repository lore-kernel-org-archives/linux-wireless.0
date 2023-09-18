Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7F1CD13D8
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Sep 2023 17:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjIRRCn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Sep 2023 13:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjIRRCj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2023 13:02:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF04AD;
        Mon, 18 Sep 2023 10:02:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23464C4339A;
        Mon, 18 Sep 2023 13:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695043179;
        bh=kPQA9DQl5bYK/XNCaMEhkUiX/FAAHEu8Orv7q/Hqp18=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IwQaoMBXvBjrMMJhvqzHZwN1eD61dA/grwAbzqbgxqD6DzTjXcQx+7mqna4Co0AYx
         37/YWBDTWVsm+p+3QOZ1KNfMrZHWpdn0zt6udYGg+JCoejTZXJSwuZCD4f9CgtkeHh
         7mUoMKPZ6j69wDUX9LuUdLy8PTX0iVLrBdg2/cBUICeSiNpd51BU9AcSB1FI4hfJDG
         sicPT8khH+KzgbWrU3DG8OIN1lPpDBGs0IVzVs3YjhYwiQpRuMwXjLLupJsNOwIPmR
         YDwOqj1uFLGwVu6kMNbYLZslLBYgtTOLiaZptpQY5Fl03+QRQgaeUrfbVJ1E+urzTU
         h1t+FtDgun1uw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] wifi: mwifiex: Fix oob check condition in
 mwifiex_process_rx_packet
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230908104308.1546501-1-treapking@chromium.org>
References: <20230908104308.1546501-1-treapking@chromium.org>
To:     Pin-yen Lin <treapking@chromium.org>
Cc:     linux-wireless@vger.kernel.org,
        Pin-yen Lin <treapking@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Polaris Pi <pinkperfect2021@gmail.com>,
        Matthew Wang <matthewmwang@chromium.org>,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169504317624.617522.1000616001928521648.kvalo@kernel.org>
Date:   Mon, 18 Sep 2023 13:19:37 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pin-yen Lin <treapking@chromium.org> wrote:

> Only skip the code path trying to access the rfc1042 headers when the
> buffer is too small, so the driver can still process packets without
> rfc1042 headers.
> 
> Fixes: 119585281617 ("wifi: mwifiex: Fix OOB and integer underflow when rx packets")
> Signed-off-by: Pin-yen Lin <treapking@chromium.org>
> Acked-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Matthew Wang <matthewmwang@chromium.org>

Patch applied to wireless.git, thanks.

aef7a0300047 wifi: mwifiex: Fix oob check condition in mwifiex_process_rx_packet

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230908104308.1546501-1-treapking@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

