Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32844 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752650AbdDLPNM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:13:12 -0400
Received: by mail-wm0-f65.google.com with SMTP id o81so7062809wmb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 08:13:06 -0700 (PDT)
Date: Wed, 12 Apr 2017 17:13:03 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: David Ahern <dsa@cumulusnetworks.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v5 1/5] netlink: extended ACK reporting
Message-ID: <20170412151303.GK1952@nanopsycho> (sfid-20170412_171335_552089_2D1C043D)
References: <20170412123408.22012-1-johannes@sipsolutions.net>
 <20170412123408.22012-2-johannes@sipsolutions.net>
 <dbc81431-487b-f218-a4c6-2caa44783d97@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dbc81431-487b-f218-a4c6-2caa44783d97@cumulusnetworks.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Apr 12, 2017 at 05:06:48PM CEST, dsa@cumulusnetworks.com wrote:
>On 4/12/17 6:34 AM, Johannes Berg wrote:
>> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
>> index b2c9c26ea30f..7df88770e029 100644
>> --- a/include/uapi/linux/netlink.h
>> +++ b/include/uapi/linux/netlink.h
>> @@ -69,6 +69,10 @@ struct nlmsghdr {
>>  #define NLM_F_CREATE	0x400	/* Create, if it does not exist	*/
>>  #define NLM_F_APPEND	0x800	/* Add to end of list		*/
>>  
>> +/* Flags for ACK message */
>> +#define NLM_F_CAPPED	0x100	/* request was capped */
>> +#define NLM_F_ACK_TLVS	0x200	/* extended ACK TVLs were included */
>> +
>>  /*
>>     4.4BSD ADD		NLM_F_CREATE|NLM_F_EXCL
>>     4.4BSD CHANGE	NLM_F_REPLACE
>> @@ -101,6 +105,33 @@ struct nlmsghdr {
>>  struct nlmsgerr {
>>  	int		error;
>>  	struct nlmsghdr msg;
>> +	/*
>> +	 * followed by the message contents unless NETLINK_CAP_ACK was set
>> +	 * or the ACK indicates success (error == 0)
>> +	 * message length is aligned with NLMSG_ALIGN()
>> +	 */
>> +	/*
>> +	 * followed by TLVs defined in enum nlmsgerr_attrs
>> +	 * if NETLINK_EXT_ACK was set
>> +	 */
>> +};
>> +
>> +/**
>> + * enum nlmsgerr_attrs - nlmsgerr attributes
>> + * @NLMSGERR_ATTR_UNUSED: unused
>> + * @NLMSGERR_ATTR_MSG: error message string (string)
>> + * @NLMSGERR_ATTR_OFFS: offset of the invalid attribute in the original
>> + *	 message, counting from the beginning of the header (u32)
>> + * @__NLMSGERR_ATTR_MAX: number of attributes
>> + * @NLMSGERR_ATTR_MAX: highest attribute number
>> + */
>> +enum nlmsgerr_attrs {
>> +	NLMSGERR_ATTR_UNUSED,
>> +	NLMSGERR_ATTR_MSG,
>
>There was a discussion about side effects of adding strings (bloat,
>internationalization). Should ATTR_MSG be removed until that is ironed
>out? Leaving it in suggests it is ok to start adding strings.

I believe that we need strings right away. Without them, this patchset
really does not make much sense.
