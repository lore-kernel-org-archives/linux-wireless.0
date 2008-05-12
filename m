Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:28048 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbYELXZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 19:25:32 -0400
Received: by an-out-0708.google.com with SMTP id d40so519459and.103
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 16:25:31 -0700 (PDT)
Message-ID: <40f31dec0805121625q4a68d591lb2af3bf76d2b90b6@mail.gmail.com> (sfid-20080513_012540_980665_9ED45DC8)
Date: Tue, 13 May 2008 02:25:31 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: Fix loop variable initializations
Cc: mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <E1JvZ2x-0005kb-TH@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <E1JvZ2x-0005kb-TH@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  +       rs->rs_phyerr = 0;
>

Do you mind also changing these to |= instead of = (just for code clarity) ?

rs->rs_phyerr = AR5K_REG_MS(rx_status->rx_status_1,
AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);

rs->rs_phyerr = AR5K_REG_MS(rx_err->rx_error_1,
AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
