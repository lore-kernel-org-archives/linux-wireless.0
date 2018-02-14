Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:45375 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161696AbeBNSQP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 13:16:15 -0500
Received: by mail-wr0-f171.google.com with SMTP id h9so863591wre.12
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2018 10:16:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 14 Feb 2018 10:16:14 -0800
Message-ID: <CALLGbRLP6czPkm_DFPTZCkzXUXQq2RdDm3kjad-5EJJBHnbz5g@mail.gmail.com> (sfid-20180214_191619_866561_AEE73B2B)
Subject: Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 14, 2018 at 8:26 AM, Jean Pierre TOSONI <jp.tosoni@acksys.fr> wrote:
> ath9k returns a wrong RSSI value for frames received in a 30ms time
> window after a channel change. The correct value is typically 10dB
> below the returned value.
>
> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX / JWX6083
> cards), during offchannel scans.
>

Is this true for ALL ath9k chips or only for the specific device? If
it's not generally true, we shouldn't be adding code that applies to
all. Perhaps a quirk or keyed to a specific chip id or DT entry or
other way to guard it?

- Steve
