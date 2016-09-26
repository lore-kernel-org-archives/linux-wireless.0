Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965171AbcIZK4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 06:56:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        "Avinash Patil" <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        "Sergei Maksimenko" <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
        <99f0c921-1230-0896-2bc5-4a12eb81dca1@quantenna.com>
Date: Mon, 26 Sep 2016 13:56:47 +0300
In-Reply-To: <99f0c921-1230-0896-2bc5-4a12eb81dca1@quantenna.com>
        (IgorMitsyanko's message of "Tue, 20 Sep 2016 21:51:25 +0300")
Message-ID: <87oa3byln4.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_125700_137758_25705EE8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IgorMitsyanko <igor.mitsyanko.os@quantenna.com> writes:

> On 09/17/2016 04:46 PM, Kalle Valo wrote:
>> <igor.mitsyanko.os@quantenna.com> writes:
>>
>>> +/* Supported rates to be advertised to the cfg80211 */
>>> +static struct ieee80211_rate qtnf_rates[] = {
>>> +	{.bitrate = 10, .hw_value = 2, },
>>> +	{.bitrate = 20, .hw_value = 4, },
>>> +	{.bitrate = 55, .hw_value = 11, },
>>> +	{.bitrate = 110, .hw_value = 22, },
>>> +	{.bitrate = 60, .hw_value = 12, },
>>> +	{.bitrate = 90, .hw_value = 18, },
>>> +	{.bitrate = 120, .hw_value = 24, },
>>> +	{.bitrate = 180, .hw_value = 36, },
>>> +	{.bitrate = 240, .hw_value = 48, },
>>> +	{.bitrate = 360, .hw_value = 72, },
>>> +	{.bitrate = 480, .hw_value = 96, },
>>> +	{.bitrate = 540, .hw_value = 108, },
>>> +};
>>> +
>>> +/* Channel definitions to be advertised to cfg80211 */
>>> +static struct ieee80211_channel qtnf_channels_2ghz[] = {
>>> +	{.center_freq = 2412, .hw_value = 1, },
>>> +	{.center_freq = 2417, .hw_value = 2, },
>>> +	{.center_freq = 2422, .hw_value = 3, },
>>> +	{.center_freq = 2427, .hw_value = 4, },
>>> +	{.center_freq = 2432, .hw_value = 5, },
>>> +	{.center_freq = 2437, .hw_value = 6, },
>>> +	{.center_freq = 2442, .hw_value = 7, },
>>> +	{.center_freq = 2447, .hw_value = 8, },
>>> +	{.center_freq = 2452, .hw_value = 9, },
>>> +	{.center_freq = 2457, .hw_value = 10, },
>>> +	{.center_freq = 2462, .hw_value = 11, },
>>> +	{.center_freq = 2467, .hw_value = 12, },
>>> +	{.center_freq = 2472, .hw_value = 13, },
>>> +	{.center_freq = 2484, .hw_value = 14, },
>>> +};
>> I guess some of these static variables could be also const, but didn't
>> check.
>
> We did some changes to this code recently: will get bands info
> (channel list, rates, capabilities etc) from wireless device itself,
> it will be in next patch revision.

For the initial submission please freeze the driver, otherwise it's pain
to review as the driver changes too much in-between review rounds. So at
this stage only minimal changes, please.

You can continue adding new features and making changes, but do those as
follow up patches and use the initial submission as the baseline for the
new patches. Once the driver is applied you can submit the rest of the
patches adding new features and they will be reviewed similarly like all
other wireless patches.

>>> +static int
>>> +qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
>>> +			    const struct qlink_event_sta_assoc *sta_assoc,
>>> +			    u16 len)
>>> +{
>>> +	const u8 *sta_addr;
>>> +	u16 frame_control;
>>> +	struct station_info sinfo = { 0 };
>>> +	size_t payload_len;
>>> +	u16 tlv_type;
>>> +	u16 tlv_value_len;
>>> +	size_t tlv_full_len;
>>> +	const struct qlink_tlv_hdr *tlv;
>>> +
>>> +	if (unlikely(len < sizeof(*sta_assoc))) {
>>> +		pr_err("%s: payload is too short (%u < %zu)\n", __func__,
>>> +		       len, sizeof(*sta_assoc));
>>> +		return -EINVAL;
>>> +	}
>>
>> I see unlikely() used a lot, I counted 145 times. Not a big issue but I
>> don't see the point. In hot path I understand using it, but not
>> everywhere.
>
> Agree, but would you suggest that we remove the ones that we already
> have but that are not really needed?

Up to you really. This isn't important, just something I found a bit
odd.

-- 
Kalle Valo
