Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38512 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbcF3LJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:09:41 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix 10.4 extended peer stats update
Date: Thu, 30 Jun 2016 11:09:31 +0000
Message-ID: <87mvm353x1.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_130943_854538_B935757C)
References: <1464851602-12969-1-git-send-email-mohammed@qca.qualcomm.com>
	<87vb0r5529.fsf@kamboji.qca.qualcomm.com>
	<87r3bf54v6.fsf@kamboji.qca.qualcomm.com>
	<20160630105951.GA10001@atheros-ThinkPad-T61>
In-Reply-To: <20160630105951.GA10001@atheros-ThinkPad-T61> (Mohammed Shafi
	Shajakhan's message of "Thu, 30 Jun 2016 16:29:51 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:

> Hi Kalle,
>
> On Thu, Jun 30, 2016 at 10:49:02AM +0000, Valo, Kalle wrote:
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>> 
>> >> @@ -261,6 +263,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>> >>  			.board = QCA4019_HW_1_0_BOARD_DATA_FILE,
>> >>  			.board_size = QCA4019_BOARD_DATA_SZ,
>> >>  			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
>> >> +			.extd_peer_stats = true,
>> >>  		},
>> >>  	},
>> >>  };
>> >
>> > This is not a hardware feature so hw_params is not really the right
>> > place to handle this. In the pending branch I tried to solve this a bit
>> > differently:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ecf4daadc7677518ec7185dbddab959ac6e2db96
>> >
>> > I added a bool "extended" to struct ath10k_fw_stats which is used to
>> > detect if extended stats are used. Would that work? Please note that I
>> > have only compile tested the patch.
>
> [shafi] thanks for taking time to do this, the change looks fine to me !
> since 'ath10k_sta_update_rx_duration' is called right after 'ath10k_wmi_pull_fw_stats'
> this should properly update the rx_duration based on the current data

Could you also run some tests to make sure? I don't trust my own code :)

-- 
Kalle Valo