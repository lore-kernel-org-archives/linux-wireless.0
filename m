Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38057 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbbJIIxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:53:45 -0400
Message-ID: <15ec1e44ce1ef8ca5a2b0c9455c71ac1.squirrel@www.codeaurora.org> (sfid-20151009_105351_042204_2FC3A8FE)
In-Reply-To: <560D4392.4060107@openwrt.org>
References: <1443582568-1216-1-git-send-email-miaoqing@codeaurora.org>
    <560D4392.4060107@openwrt.org>
Date: Fri, 9 Oct 2015 08:53:44 -0000
Subject: Re: [PATCH v2] ath9k: feeding entropy in kernel from ADC capture
From: miaoqing@codeaurora.org
To: "Felix Fietkau" <nbd@openwrt.org>
Cc: miaoqing@codeaurora.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, lkp@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Felix. You mentioned 'Polling every 10 milliseconds' is not right,
the kthread will always sleep until when the condition
'ENTROPY_BITS(&input_pool) <=
random_write_wakeup_bits'(add_hwgenerator_randomness()) is true.  And
ath9k_rng_data_read() almost w/o failure, I will add unlikely in patch v3.

- Miaoqing

> On 2015-09-30 05:09, miaoqing@codeaurora.org wrote:
>> From: Miaoqing Pan <miaoqing@codeaurora.org>
>>
>> This patch is derived from
>> commit 6301566e0b2d ("ath9k: export HW random number generator"),
>>
>> We evaluated the entropy of the ADC data on QCA9531, QCA9561, QCA955x,
>> and AR9340, and it has sufficient quality random data (at least 10 bits
>> and up to 22 bits of min-entropy for a 32-bit value). We conservatively
>> assume the min-entropy is 10 bits out of 32 bits. Thus,
>> ATH9K_RNG_BUF_SIZE
>> is set to 320 (u32) i.e., 1.25 kilobytes of data is inserted to fill up
>> the pool as soon as the entropy counter becomes 896/4096 (set by
>> random.c).
>> Since ADC was not designed to be a dedicated HW RNG, we do not want to
>> bind
>> it to /dev/hwrng framework directly. This patch feeds the entropy
>> directly
>> from the WiFi driver to the input pool. The ADC register output is only
>> used as a seed for the Linux entropy pool. No conditioning is needed,
>> since all the conditioning is performed by the pool itself.
>>
>> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/Kconfig  |  11 ++++
>>  drivers/net/wireless/ath/ath9k/Makefile |   1 +
>>  drivers/net/wireless/ath/ath9k/ath9k.h  |  22 +++++++
>>  drivers/net/wireless/ath/ath9k/main.c   |   4 ++
>>  drivers/net/wireless/ath/ath9k/rng.c    | 106
>> ++++++++++++++++++++++++++++++++
>>  5 files changed, 144 insertions(+)
>>  create mode 100644 drivers/net/wireless/ath/ath9k/rng.c
>>
>
>> diff --git a/drivers/net/wireless/ath/ath9k/rng.c
>> b/drivers/net/wireless/ath/ath9k/rng.c
>> new file mode 100644
>> index 0000000..93a7485
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath9k/rng.c
>> [...]
>> +static int ath9k_rng_kthread(void *data)
>> +{
>> +	int bytes_read;
>> +	struct ath_softc *sc = data;
>> +	u32 *rng_buf;
>> +
>> +	rng_buf = kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
>> +	if (!rng_buf)
>> +		goto out;
>> +
>> +	while (!kthread_should_stop()) {
>> +		bytes_read = ath9k_rng_data_read(sc, rng_buf,
>> +						 ATH9K_RNG_BUF_SIZE);
>> +		if (!bytes_read) {
>> +			msleep_interruptible(10);
>> +			continue;
>> +		}
>> +
>> +		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
>> +					   ATH9K_RNG_ENTROPY(bytes_read));
> Polling every 10 milliseconds seems a bit excessive to me. Think about
> all those useless wakeups per second that this will produce on battery
> powered devices.
> How about polling more data without sleeping when the thread starts, and
> then afterwards only poll once every few seconds?
>
> - Felix
>

