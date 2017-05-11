Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55914 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932250AbdEKLq6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 07:46:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v2 0/4] rtlwifi: btcoex: Remove all references to BT_AUTO_REPORT_ONLY* parameters
References: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
Date: Thu, 11 May 2017 14:46:50 +0300
In-Reply-To: <20170504184701.16560-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Thu, 4 May 2017 13:46:57 -0500")
Message-ID: <87a86jvcnp.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_134742_870865_5CC52451)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> The btcoex code uses #if constructs to compile conditional code. There
> is no way to modify this behavior without editting the source. This
> logic is converted into regular if statements that interrogate a
> boolean variable in a structure known to all routines.

Well technically these are still dead code as there's no way to enable
those. But this is much better than before, now at least we can compile
test the whole code. So thanks for fixing it.

> The new form does not provide any mechanism for dynamic changes, but
> it now is in a form whereby module parameters could be added to select
> the behavior at module load time. In these patches, a number of
> routines removed because they were not referenced must be restored.

We should keep the number of module parameters as low as possible. If
I'm understanding correctly changing the behaviour is needed for testing
purposes? In that case I suspect that debugfs would be more approriate
interface to enable these.

-- 
Kalle Valo
