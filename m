Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34702 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbbFBOmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 10:42:35 -0400
Received: by oifu123 with SMTP id u123so127207866oif.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 07:42:35 -0700 (PDT)
Date: Tue, 2 Jun 2015 09:42:31 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Add 60GHz regulatory
 rules for Russia (RU)
Message-ID: <20150602144231.GA31648@ubuntu-hedt> (sfid-20150602_164238_773529_7DB371B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2015 at 05:04:09PM +0300, Vladimir Kondratiev wrote:
> Source is document named
> Changes to NLA 124_Order №129_22042015.pdf
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  db.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/db.txt b/db.txt
> index f361030..79dac92 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -978,6 +978,8 @@ country RU: DFS-ETSI
>  	(5250 - 5330 @ 80), (20), DFS
>  	(5650 - 5730 @ 80), (30), DFS
>  	(5735 - 5835 @ 80), (30)
> +	# 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
> +	(57000 - 66000 @ 2160), (40)

It looks like your tree is out of date and missing:

  aa1d66d wireless-regdb: Disable VHT80 where 40/80 MHz on 5 GHz is not allowed

I see that you directed the patch at John, so I'm guessing that you're
still using his tree. I took over maintainership of the database in
December, and you should be using this repo for new work:

  git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git

Thanks,
Seth
