Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2CUFVC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 01:21:02 -0400
Message-ID: <4F696530.9040304@qca.qualcomm.com> (sfid-20120321_062116_479732_899BB204)
Date: Wed, 21 Mar 2012 10:50:48 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Youngsin Lee <youngsin@qualcomm.com>,
	Senthil Kumar Balasubramanian <senthilb@qca.qualcomm.com>,
	Vipin Mehta <vipimeht@qca.qualcomm.com>,
	<yahuan@qca.qualcomm.com>, <jjan@qca.qualcomm.com>,
	<vthiagar@qca.qualcomm.com>, <henrykim@qualcomm.com>,
	<jouni@qca.qualcomm.com>, <athiruve@qca.qualcomm.com>,
	<cjkim@qualcomm.com>, <philipk@qca.qualcomm.com>,
	<sunnykim@qualcomm.com>, <sskwak@qualcomm.com>,
	<kkim@qualcomm.com>, <mattbyun@qualcomm.com>,
	<ryanlee@qualcomm.com>, <simbap@qualcomm.com>,
	<krislee@qualcomm.com>, <conner@qualcomm.com>,
	<hojinkim@qualcomm.com>, <honglee@qualcomm.com>,
	<johnwkim@qualcomm.com>
Subject: Re: [PATCH v2] cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
References: <1332252225-17531-1-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1332252225-17531-1-git-send-email-mcgrof@frijolero.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 March 2012 07:33 PM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez"<mcgrof@frijolero.org>
>
> It has happened twice now where elaborate troubleshooting has
> undergone on systems where CONFIG_CFG80211_INTERNAL_REGDB [0]
> has been set but yet net/wireless/db.txt was not updated.
>
> Despite the documentation on this it seems system integrators could
> use some more help with this, so throw out a kernel warning at boot time
> when their database is empty.
>
> This does mean that the error-prone system integrator won't likely
> realize the issue until they boot the machine but -- it does not seem
> to make sense to enable a build bug breaking random build testing.
>
> [0] http://wireless.kernel.org/en/developers/Regulatory/CRDA#CONFIG_CFG80211_INTERNAL_REGDB
>
> Cc: Stephen Rothwell<sfr@canb.auug.org.au>
> Cc: Youngsin Lee<youngsin@qualcomm.com>
> Cc: Raja Mani<rmani@qca.qualcomm.com>
> Cc: Senthil Kumar Balasubramanian<senthilb@qca.qualcomm.com>
> Cc: Vipin Mehta<vipimeht@qca.qualcomm.com>
> Cc: yahuan@qca.qualcomm.com
> Cc: jjan@qca.qualcomm.com
> Cc: vthiagar@qca.qualcomm.com
> Cc: henrykim@qualcomm.com
> Cc: jouni@qca.qualcomm.com
> Cc: athiruve@qca.qualcomm.com
> Cc: cjkim@qualcomm.com
> Cc: philipk@qca.qualcomm.com
> Cc: sunnykim@qualcomm.com
> Cc: sskwak@qualcomm.com
> Cc: kkim@qualcomm.com
> Cc: mattbyun@qualcomm.com
> Cc: ryanlee@qualcomm.com
> Cc: simbap@qualcomm.com
> Cc: krislee@qualcomm.com
> Cc: conner@qualcomm.com
> Cc: hojinkim@qualcomm.com
> Cc: honglee@qualcomm.com
> Cc: johnwkim@qualcomm.com
> Signed-off-by: Luis R. Rodriguez<mcgrof@frijolero.org>
> ---
>   net/wireless/reg.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index e9a0ac8..7b613c4 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -388,7 +388,15 @@ static void reg_regdb_query(const char *alpha2)
>
>   	schedule_work(&reg_regdb_work);
>   }
> +
> +/* Feel free to add any other sanity checks here */
> +static void reg_regdb_size_check(void)
> +{
> +	/* We should ideally BUILD_BUG_ON() but then random builds would fail */
> +	WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
> +}
>   #else
> +static inline void reg_regdb_size_check(void) {}
>   static inline void reg_regdb_query(const char *alpha2) {}
>   #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
>
> @@ -2367,6 +2375,7 @@ void /* __init_or_exit */ regulatory_exit(void)
>   	mutex_lock(&cfg80211_mutex);
>   	mutex_lock(&reg_mutex);
>
> +	reg_regdb_size_check();

Just curious question, Don't we have to check internal regdb size in
init time (i.e, regulatory_init()) instead of in regulatory_exit() ?

Because, we would get warning ONLY at exit time in this case.

>   	reset_regdomains(true);
>
>   	dev_set_uevent_suppress(&reg_pdev->dev, true);
