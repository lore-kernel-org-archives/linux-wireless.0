Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45879 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcKNLUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 06:20:51 -0500
Date: Mon, 14 Nov 2016 14:20:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: aviya.erenfeld@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] iwlwifi: mvm: use dev_coredumpsg()
Message-ID: <20161114112039.GA21931@mwanda> (sfid-20161114_122055_099588_3F05CC96)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Aviya Erenfeld,

The patch 7e62a699aafb: "iwlwifi: mvm: use dev_coredumpsg()" from Sep
20, 2016, leads to the following static checker warning:

	drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:821 iwl_mvm_fw_error_dump()
	error: we previously assumed 'fw_error_dump->trans_ptr' could be null (see line 809)

drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
   805  dump_trans_data:
   806          fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
   807                                                         mvm->fw_dump_trig);
   808          fw_error_dump->op_mode_len = file_len;
   809          if (fw_error_dump->trans_ptr)
   810                  file_len += fw_error_dump->trans_ptr->len;

We assume ->trans_ptr can be NULL.

   811          dump_file->file_len = cpu_to_le32(file_len);
   812  
   813          sg_dump_data = alloc_sgtable(file_len);

That probably means file_len is zero?  (didn't look).  That means
sg_dump_data is ZERO_SIZE_PTR (16).

   814          if (sg_dump_data) {
   815                  sg_pcopy_from_buffer(sg_dump_data,
   816                                       sg_nents(sg_dump_data),
   817                                       fw_error_dump->op_mode_ptr,
   818                                       fw_error_dump->op_mode_len, 0);
   819                  sg_pcopy_from_buffer(sg_dump_data,
   820                                       sg_nents(sg_dump_data),
   821                                       fw_error_dump->trans_ptr->data,

Leading to an oops.

   822                                       fw_error_dump->trans_ptr->len,
   823                                       fw_error_dump->op_mode_len);
   824                  dev_coredumpsg(mvm->trans->dev, sg_dump_data, file_len,
   825                                 GFP_KERNEL);
   826          }
   827          vfree(fw_error_dump->op_mode_ptr);
   828          vfree(fw_error_dump->trans_ptr);
   829          kfree(fw_error_dump);
   830  
   831  out:
   832          iwl_mvm_free_fw_dump_desc(mvm);
   833          mvm->fw_dump_trig = NULL;
   834          clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
   835  }

regards,
dan carpenter
