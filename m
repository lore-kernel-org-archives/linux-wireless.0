Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752750AbdDJNGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 09:06:18 -0400
Date: Mon, 10 Apr 2017 15:06:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2] rt2x00: reverse external PA capability flag logic
Message-ID: <20170410130614.GA8462@redhat.com> (sfid-20170410_150621_938342_DD93B36B)
References: <201704101003.oA28M6Nz%fengguang.wu@intel.com>
 <20170410120822.GA1833@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170410120822.GA1833@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 10, 2017 at 02:08:27PM +0200, Daniel Golle wrote:
> -	rt2800_rfcsr_write(rt2x00dev, 51, (tx0_int_pa ? 0x7f : 0x52));
<snip>
> +	rt2800_rfcsr_write(rt2x00dev, 51, (tx0_ext_pa ? 0x52 : 0x72));

Seems unintended value change from 0x7f to 0x72.

Stanislaw
