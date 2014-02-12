Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaBLMOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 07:14:10 -0500
Date: Wed, 12 Feb 2014 13:13:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] iwlwifi: refactor the TX / RX ampdu override
Message-ID: <20140212121314.GE1315@redhat.com> (sfid-20140212_131413_995089_32DA45E4)
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
 <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 01:19:49PM +0200, Emmanuel Grumbach wrote:
> Note that this modifies the module parameter values / string
> which means that distro will need to update their *.conf file
> (if any).

Hmm, this is not something that I would like to do ...

> -#define IWL_DISABLE_HT_ALL	BIT(0)
> -#define IWL_DISABLE_HT_TXAGG	BIT(1)
> -#define IWL_DISABLE_HT_RXAGG	BIT(2)
> -#define IWL_DISABLE_HT_ALL	BIT(1)
> +#define IWL_DISABLE_HT_TXAGG	BIT(1)
> +#define IWL_DISABLE_HT_RXAGG	BIT(1)
> +#define IWL_ENABLE_HT_TXAGG	BIT(2)
> +#define IWL_ENABLE_HT_RXAGG	BIT(3)

I think we can keep IWL_DISABLE_HT_ALL option. I should be possible to
make some per-device type default settings and if disable_11n == 0 use
them. Otherwise use settings from module parameter. Will that work ?

Stanislaw
