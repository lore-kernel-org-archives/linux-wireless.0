Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41536 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401AbYDQToq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 15:44:46 -0400
Date: Thu, 17 Apr 2008 21:44:37 +0200
From: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Message-ID: <20080417194437.GA18291@Chamillionaire.breakpoint.cc> (sfid-20080417_204513_576386_F46F4F61)
References: <1208448814.9212.270.camel@pmac.infradead.org> <1208455363.20193.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1208455363.20193.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams | 2008-04-17 14:02:43 [-0400]:

>On Thu, 2008-04-17 at 17:13 +0100, David Woodhouse wrote:
>> We removed CMD_MESH_ACCESS from the big case statements and provided
>> lbs_mesh_access() instead.... but we missed one user. Fix it.
>> 
>> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>
>Acked-by: Dan Williams <dcbw@redhat.com>
Hmmm. This patch actually reminds me of something I was going to do. I
don't really see the big difference between this and [1]. I have to
exert myself to get on your auto-ack list...


[1]
http://lists.infradead.org/pipermail/libertas-dev/2008-March/001281.html

>> 
>> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
>> index 21e6f98..9460300 100644
>> --- a/drivers/net/wireless/libertas/ethtool.c
>> +++ b/drivers/net/wireless/libertas/ethtool.c
>> @@ -106,8 +106,8 @@ done:
>>          return ret;
>>  }
>>  
>> -static void lbs_ethtool_get_stats(struct net_device * dev,
>> -				struct ethtool_stats * stats, u64 * data)
>> +static void lbs_ethtool_get_stats(struct net_device *dev,
>> +				  struct ethtool_stats *stats, u64 *data)
>>  {
>>  	struct lbs_private *priv = dev->priv;
>>  	struct cmd_ds_mesh_access mesh_access;
>> @@ -116,9 +116,7 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
>>  	lbs_deb_enter(LBS_DEB_ETHTOOL);
>>  
>>  	/* Get Mesh Statistics */
>> -	ret = lbs_prepare_and_send_command(priv,
>> -			CMD_MESH_ACCESS, CMD_ACT_MESH_GET_STATS,
>> -			CMD_OPTION_WAITFORRSP, 0, &mesh_access);
>> +	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_STATS, &mesh_access);
>>  
>>  	if (ret)
>>  		return;
>> 

Sebastian
