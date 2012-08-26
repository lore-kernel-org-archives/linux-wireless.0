Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38811 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2HZXsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 19:48:53 -0400
Received: by eekc1 with SMTP id c1so731476eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 16:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346014505-7554-2-git-send-email-ordex@autistici.org>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org> <1346014505-7554-2-git-send-email-ordex@autistici.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 27 Aug 2012 09:48:31 +1000
Message-ID: <CAGRGNgUoNnuh_23qzULJyJcvMUgNpUxFnZjaAcGj26_jrTHdeA@mail.gmail.com> (sfid-20120827_014933_243805_D149F43D)
Subject: Re: [PATCHv2 2/2] ath9k_htc: advertise allowed VIFs combination
To: Antonio Quartulli <ordex@autistici.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio,

On Mon, Aug 27, 2012 at 6:55 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> This driver now advertises its allowed VIFs combinations to the mac80211
> sublayer.
>
> Other than that, practical tests shown that ath9k_htc devices allow an IBSS VIF
> to coexist with VIF set up on other modes. This patch removes the check which
> block the creation of any other VIF whenever an IBSS one is already present.

These two patches should really be applied in the opposite order:

You should add the interface combination data (this patch) then remove
the old checking code.

This way there's not a window (admittedly only one patch) where the
interface combinations aren't enforced.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
