Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932107AbeCKPId (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Mar 2018 11:08:33 -0400
Subject: Re: [PATCH] wcn36xx: Add support for FTM WLAN
To: Kalle Valo <kvalo@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Eyal Ilsar <eilsar@codeaurora.org>
References: <20180228071328.5605-1-rfried@codeaurora.org>
 <878tb0clha.fsf@kamboji.qca.qualcomm.com>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <092a49fc-81dc-8349-eacf-91bdeb158952@codeaurora.org> (sfid-20180311_160837_258308_380F02A4)
Date: Sun, 11 Mar 2018 17:08:28 +0200
MIME-Version: 1.0
In-Reply-To: <878tb0clha.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 3/10/2018 11:45 AM, Kalle Valo wrote:
> Ramon Fried <rfried@codeaurora.org> writes:
>
>> From: Eyal Ilsar <eilsar@codeaurora.org>
>>
>> Introduced infrastructure for supporting FTM WLAN in user space exposing
>> the netlink channel from the kernel WLAN driver.
> What's FTM WLAN? Don't assume that people know all the acronyms.
FTM is factory test mode if I recall correctly, but you're right. I elaborate more in the commit message.
>
> This included:
>> 1) Registered wcn36xx driver to testmode callback from netlink
>> 2) Added testmode callback implementation to handle incoming FTM commands
>> 3) Added FTM command packet structure
>> 4) Added handling for GET_BUILD_RELEASE_NUMBER (msgid=0x32A2)
>> 5) Added generic handling for all PTT_MSG packets
> I don't remember the english grammar terminology, but in the commit log
> use the form "register", "add" instead of "registered", "added".
OK. Will fix.
>> +struct wcn36xx_hal_process_ptt_msg_rsp_msg {
>> +	struct wcn36xx_hal_msg_header header;
>> +
>> +	/* FTM Command response status */
>> +	u32   ptt_msg_resp_status;
> Unnecessary whitespace after u32.
Thanks.

>> +static int wcn36xx_smd_process_ptt_msg_rsp(void *buf, size_t len,
>> +			void **p_ptt_rsp_msg)
>> +{
>> +	struct wcn36xx_hal_process_ptt_msg_rsp_msg *rsp;
>> +	int ret = 0;
>> +
>> +	ret = wcn36xx_smd_rsp_status_check(buf, len);
>> +	if (ret)
>> +		return ret;
>> +	rsp = (struct wcn36xx_hal_process_ptt_msg_rsp_msg *)buf;
>> +	wcn36xx_dbg(WCN36XX_DBG_HAL, "process ptt msg responded with length %d\n",
>> +			rsp->header.len);
>> +	wcn36xx_dbg_dump(WCN36XX_DBG_HAL_DUMP, "HAL_PTT_MSG_RSP:", rsp->ptt_msg,
>> +			rsp->header.len - sizeof(rsp->ptt_msg_resp_status));
>> +	if (rsp->header.len > 0) {
>> +		*p_ptt_rsp_msg = kmalloc(rsp->header.len, GFP_ATOMIC);
>> +		memcpy(*p_ptt_rsp_msg, rsp->ptt_msg, rsp->header.len);
>> +	}
>> +	return ret;
>> +}
> Adding few empty lines to the function would make it more readable.
Ok, I will add.
>> @@ -2330,6 +2399,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
>>  	struct ieee80211_hw *hw = priv;
>>  	struct wcn36xx *wcn = hw->priv;
>>  	struct wcn36xx_hal_ind_msg *msg_ind;
>> +
>>  	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
> Unrelated change.
Nice catch. thanks.
>> +int wcn36xx_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>> +		  void *data, int len)
>> +{
>> +	struct wcn36xx *wcn = hw->priv;
>> +	struct nlattr *tb[WCN36XX_TM_ATTR_MAX + 1];
>> +	int ret = 0;
>> +	unsigned short attr;
>> +
>> +	wcn36xx_dbg_dump(WCN36XX_DBG_TESTMODE_DUMP, "Data:", data, len);
>> +	ret = nla_parse(tb, WCN36XX_TM_ATTR_MAX, data, len,
>> +			wcn36xx_tm_policy, NULL);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (!tb[WCN36XX_TM_ATTR_CMD])
>> +		return -EINVAL;
>> +
>> +	attr = nla_get_u16(tb[WCN36XX_TM_ATTR_CMD]);
>> +
>> +	switch (attr) {
>> +	case WCN36XX_TM_CMD_START:
>> +	case WCN36XX_TM_CMD_STOP:
>> +		// N/A to this driver as it does not need to switch state
>> +		break;
> [...]
>
>> +enum wcn36xx_tm_cmd {
>> +	/* For backwards compatibility
>> +	 */
>> +	WCN36XX_TM_CMD_START = 1,
>> +
>> +	/* For backwards compatibility
>> +	 */
>> +	WCN36XX_TM_CMD_STOP = 2,
> This looks odd. If wcn36xx does not need START and STOP commands why add
> those in the first place?
AFAIK the user-space app sends these commands, but I will check again. in WCN36xx unlike ATH10k it's not needed to do any transition or replace the firmware
to go in test mode, but I assume that if this command arrives we should return success.

>
