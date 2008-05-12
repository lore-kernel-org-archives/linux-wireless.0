Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44394 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbYELUvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 16:51:38 -0400
Date: Mon, 12 May 2008 22:51:36 +0200
From: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] [NET] libertas: check for mesh support before trying
	to use it
Message-ID: <20080512205136.GA27705@Chamillionaire.breakpoint.cc> (sfid-20080512_225143_705714_2DD728DD)
References: <1208448814.9212.270.camel@pmac.infradead.org> <1208455363.20193.3.camel@localhost.localdomain> <20080417194437.GA18291@Chamillionaire.breakpoint.cc> <20080510072428.GA1153@Chamillionaire.breakpoint.cc> <1210610056.23717.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1210610056.23717.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams | 2008-05-12 12:34:16 [-0400]:

>> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
>> index dcfdb40..a79d698 100644
>> --- a/drivers/net/wireless/libertas/ethtool.c
>> +++ b/drivers/net/wireless/libertas/ethtool.c
>> @@ -113,8 +113,14 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
>>  
>>  static int lbs_ethtool_get_sset_count(struct net_device * dev, int sset)
>>  {
>> +	struct lbs_private *priv = dev->priv;
>> +
>>  	switch (sset) {
>>  	case ETH_SS_STATS:
>> +
>> +		if (!priv->mesh_tlv)
>> +
>
>We usually use
>
>if (!priv->mesh_dev)
>
>for checking whether mesh is open or not... Will that not work here?
>
Well, if this is the case than you can pick David's patch which does
this [1]. If you fine with this than I could add a patch description and
things like that :)

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/13707
>Dan
Sebastian
